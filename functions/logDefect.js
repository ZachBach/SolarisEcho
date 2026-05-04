const prisma = require('./prismaClient.js')
const { LogDefectSchema } = require('../src/schemas.js')
const { parseBody, created, badRequest, notFound, serverError } = require('./utils.js')

exports.handler = async (event) => {
  try {
    const parsed = LogDefectSchema.safeParse(parseBody(event))
    if (!parsed.success) return badRequest(parsed.error.flatten())

    const { workOrderId, ...defectData } = parsed.data

    const workOrder = await prisma.workOrder.findUnique({ where: { id: workOrderId } })
    if (!workOrder) return notFound('WorkOrder not found')

    const defect = await prisma.defect.create({ data: { workOrderId, ...defectData } })

    return created({ id: defect.id })
  } catch (err) {
    return serverError(err)
  }
}
