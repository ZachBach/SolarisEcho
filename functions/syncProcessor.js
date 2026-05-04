const { handler: createWorkOrder } = require('./createWorkOrder.js')
const { handler: logDefect } = require('./logDefect.js')
const { handler: updateWorkOrderStatus } = require('./updateWorkOrderStatus.js')
const { badRequest } = require('./utils.js')

const HANDLERS = { createWorkOrder, logDefect, updateWorkOrderStatus }
const VALID = Object.keys(HANDLERS).join(', ')

// Receives MQTT messages from AWS IoT Rule on topic factory/+/create
// Expected payload: { action: "createWorkOrder"|"logDefect"|"updateWorkOrderStatus", ...data }
exports.handler = async (event) => {
  const payload = typeof event === 'string' ? JSON.parse(event) : event
  const { action, ...data } = payload ?? {}

  if (!action || !HANDLERS[action]) {
    return badRequest(`Unknown action: "${action}". Valid: ${VALID}`)
  }

  return HANDLERS[action](data)
}
