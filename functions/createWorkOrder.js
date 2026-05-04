const prisma = require('./prismaClient.js')
const { CreateWorkOrderSchema } = require('../src/schemas.js')
const { parseBody, created, badRequest, serverError } = require('./utils.js')

exports.handler = async (event) => {
  try {
    const parsed = CreateWorkOrderSchema.safeParse(parseBody(event))
    if (!parsed.success) return badRequest(parsed.error.flatten())

    const { dueDate, ...rest } = parsed.data
    const workOrder = await prisma.workOrder.create({
      data: { ...rest, dueDate: dueDate ? new Date(dueDate) : undefined },
    })

    return created({ id: workOrder.id })
  } catch (err) {
    return serverError(err)
  }
}
