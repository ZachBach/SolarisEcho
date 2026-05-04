const { z } = require('zod')

const WorkOrderStatus = z.enum(['PLANNED', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED', 'CANCELLED'])
const DefectSeverity = z.enum(['CRITICAL', 'HIGH', 'MEDIUM', 'LOW'])
const DefectDisposition = z.enum(['OPEN', 'REWORK', 'SCRAP', 'USE_AS_IS', 'PENDING_REVIEW'])

const CreateWorkOrderSchema = z.object({
  partNumber: z.string().min(1),
  serialNumber: z.string().optional(),
  quantity: z.coerce.number().int().positive().default(1),
  status: WorkOrderStatus.default('PLANNED'),
  dueDate: z.string().optional(),
  assignedTo: z.string().optional(),
  currentStep: z.string().optional(),
  notes: z.string().optional(),
})

const UpdateWorkOrderStatusSchema = z.object({
  workOrderId: z.string().min(1),
  newStatus: WorkOrderStatus,
  changedBy: z.string().optional(),
})

const LogDefectSchema = z.object({
  workOrderId: z.string().min(1),
  defectType: z.string().min(1),
  severity: DefectSeverity,
  disposition: DefectDisposition.default('OPEN'),
  description: z.string().optional(),
  photoUrl: z.string().url().optional(),
})

module.exports = { CreateWorkOrderSchema, UpdateWorkOrderStatusSchema, LogDefectSchema }
