function parseBody(event) {
  if (!event) return {}
  if (event.body) return typeof event.body === 'string' ? JSON.parse(event.body) : event.body
  return event
}

const res = (statusCode, data) => ({ statusCode, body: JSON.stringify(data) })

const ok          = (data) => res(200, data)
const created     = (data) => res(201, data)
const badRequest  = (err)  => res(400, { error: err })
const notFound    = (msg)  => res(404, { error: msg })
const serverError = (err)  => res(500, { error: err?.message ?? 'Internal server error' })

module.exports = { parseBody, ok, created, badRequest, notFound, serverError }
