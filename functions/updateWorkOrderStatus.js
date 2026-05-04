const prisma = require('./prismaClient.js')
const { UpdateWorkOrderStatusSchema } = require('../src/schemas.js')
const { parseBody, ok, badRequest, notFound, serverError } = require('./utils.js')

exports.handler = async (event) => {
  try {
    const parsed = UpdateWorkOrderStatusSchema.safeParse(parseBody(event))
    if (!parsed.success) return badRequest(parsed.error.flatten())

    const { workOrderId, newStatus, changedBy } = parsed.data

    const existing = await prisma.workOrder.findUnique({ where: { id: workOrderId } })
    if (!existing) return notFound('WorkOrder not found')

    const updated = await prisma.workOrder.update({
      where: { id: workOrderId },
      data: { status: newStatus },
    })

    await prisma.auditLog.create({
      data: {
        action: 'UPDATE',
        entityType: 'WorkOrder',
        entityId: workOrderId,
        changedBy: changedBy ?? null,
        beforeState: { status: existing.status },
        afterState: { status: newStatus },
        workOrderId,
      },
    })

    return ok({ id: updated.id, status: updated.status })
  } catch (err) {
    return serverError(err)
  }
}
