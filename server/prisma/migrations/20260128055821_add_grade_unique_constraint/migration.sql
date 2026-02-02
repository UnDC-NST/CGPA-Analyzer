/*
  Warnings:

  - A unique constraint covering the columns `[collegeId,gradeLetter]` on the table `Grade` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateTable
CREATE TABLE "AssessmentTemplate" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "userId" BIGINT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AssessmentTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssessmentComponent" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "weightage" DOUBLE PRECISION NOT NULL,
    "maxScore" DOUBLE PRECISION NOT NULL,
    "templateId" BIGINT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AssessmentComponent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubjectAssessment" (
    "id" BIGSERIAL NOT NULL,
    "subjectId" BIGINT NOT NULL,
    "templateId" BIGINT NOT NULL,
    "predictedGrade" TEXT,
    "predictedGradePoint" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SubjectAssessment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssessmentScore" (
    "id" BIGSERIAL NOT NULL,
    "componentId" BIGINT NOT NULL,
    "subjectAssessmentId" BIGINT NOT NULL,
    "scoreObtained" DOUBLE PRECISION NOT NULL,
    "maxScore" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AssessmentScore_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PredictorSemester" (
    "id" BIGSERIAL NOT NULL,
    "userId" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "targetCGPA" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PredictorSemester_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PredictorSubject" (
    "id" BIGSERIAL NOT NULL,
    "semesterId" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "credits" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PredictorSubject_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PredictorComponent" (
    "id" BIGSERIAL NOT NULL,
    "subjectId" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "maxMarks" DOUBLE PRECISION NOT NULL,
    "obtainedMarks" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PredictorComponent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SubjectAssessment_subjectId_templateId_key" ON "SubjectAssessment"("subjectId", "templateId");

-- CreateIndex
CREATE UNIQUE INDEX "AssessmentScore_componentId_subjectAssessmentId_key" ON "AssessmentScore"("componentId", "subjectAssessmentId");

-- CreateIndex
CREATE UNIQUE INDEX "Grade_collegeId_gradeLetter_key" ON "Grade"("collegeId", "gradeLetter");

-- AddForeignKey
ALTER TABLE "AssessmentComponent" ADD CONSTRAINT "AssessmentComponent_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "AssessmentTemplate"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubjectAssessment" ADD CONSTRAINT "SubjectAssessment_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "Subject"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubjectAssessment" ADD CONSTRAINT "SubjectAssessment_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "AssessmentTemplate"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssessmentScore" ADD CONSTRAINT "AssessmentScore_componentId_fkey" FOREIGN KEY ("componentId") REFERENCES "AssessmentComponent"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssessmentScore" ADD CONSTRAINT "AssessmentScore_subjectAssessmentId_fkey" FOREIGN KEY ("subjectAssessmentId") REFERENCES "SubjectAssessment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PredictorSemester" ADD CONSTRAINT "PredictorSemester_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PredictorSubject" ADD CONSTRAINT "PredictorSubject_semesterId_fkey" FOREIGN KEY ("semesterId") REFERENCES "PredictorSemester"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PredictorComponent" ADD CONSTRAINT "PredictorComponent_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "PredictorSubject"("id") ON DELETE CASCADE ON UPDATE CASCADE;
