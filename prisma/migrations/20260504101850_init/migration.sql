-- CreateEnum
CREATE TYPE "WorkOrderStatus" AS ENUM ('PLANNED', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "DefectSeverity" AS ENUM ('CRITICAL', 'HIGH', 'MEDIUM', 'LOW');

-- CreateEnum
CREATE TYPE "DefectDisposition" AS ENUM ('OPEN', 'REWORK', 'SCRAP', 'USE_AS_IS', 'PENDING_REVIEW');

-- CreateEnum
CREATE TYPE "AuditAction" AS ENUM ('CREATE', 'UPDATE', 'DELETE');

-- CreateTable
CREATE TABLE "WorkOrder" (
    "id" TEXT NOT NULL,
    "partNumber" TEXT NOT NULL,
    "serialNumber" TEXT,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "status" "WorkOrderStatus" NOT NULL DEFAULT 'PLANNED',
    "dueDate" TIMESTAMP(3),
    "assignedTo" TEXT,
    "currentStep" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "WorkOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Defect" (
    "id" TEXT NOT NULL,
    "workOrderId" TEXT NOT NULL,
    "defectType" TEXT NOT NULL,
    "severity" "DefectSeverity" NOT NULL,
    "disposition" "DefectDisposition" NOT NULL DEFAULT 'OPEN',
    "description" TEXT,
    "photoUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Defect_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "engineering_changes" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "approvedBy" TEXT,
    "approvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "engineering_changes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Effectivity" (
    "id" TEXT NOT NULL,
    "engineeringChangeId" TEXT NOT NULL,
    "serialNumberFrom" TEXT,
    "serialNumberTo" TEXT,
    "batchId" TEXT,
    "effectiveDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Effectivity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkOrderEffectivity" (
    "id" TEXT NOT NULL,
    "workOrderId" TEXT NOT NULL,
    "effectivityId" TEXT NOT NULL,

    CONSTRAINT "WorkOrderEffectivity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "action" "AuditAction" NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "changedBy" TEXT,
    "beforeState" JSONB,
    "afterState" JSONB,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "workOrderId" TEXT,
    "engineeringChangeId" TEXT,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Defect_workOrderId_idx" ON "Defect"("workOrderId");

-- CreateIndex
CREATE INDEX "Defect_severity_idx" ON "Defect"("severity");

-- CreateIndex
CREATE INDEX "Defect_disposition_idx" ON "Defect"("disposition");

-- CreateIndex
CREATE UNIQUE INDEX "WorkOrderEffectivity_workOrderId_effectivityId_key" ON "WorkOrderEffectivity"("workOrderId", "effectivityId");

-- CreateIndex
CREATE INDEX "AuditLog_entityType_entityId_idx" ON "AuditLog"("entityType", "entityId");

-- AddForeignKey
ALTER TABLE "Defect" ADD CONSTRAINT "Defect_workOrderId_fkey" FOREIGN KEY ("workOrderId") REFERENCES "WorkOrder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Effectivity" ADD CONSTRAINT "Effectivity_engineeringChangeId_fkey" FOREIGN KEY ("engineeringChangeId") REFERENCES "engineering_changes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkOrderEffectivity" ADD CONSTRAINT "WorkOrderEffectivity_workOrderId_fkey" FOREIGN KEY ("workOrderId") REFERENCES "WorkOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkOrderEffectivity" ADD CONSTRAINT "WorkOrderEffectivity_effectivityId_fkey" FOREIGN KEY ("effectivityId") REFERENCES "Effectivity"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_workOrderId_fkey" FOREIGN KEY ("workOrderId") REFERENCES "WorkOrder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_engineeringChangeId_fkey" FOREIGN KEY ("engineeringChangeId") REFERENCES "engineering_changes"("id") ON DELETE SET NULL ON UPDATE CASCADE;
