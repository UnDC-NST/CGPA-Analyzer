import { PrismaClient } from '../generated/prisma/index.js';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seeding...');

  // Create colleges with different grading scales
  const colleges = [
    {
      name: 'Newton School of Technology, ADYPU',
      gradingScale: 'TEN_POINT',
      gradingDetails: {
        description: '10-point grading scale',
        maxGPA: 10
      }
    },
    {
      name: 'Newton School of Technology, Rishihood',
      gradingScale: 'TEN_POINT',
      gradingDetails: {
        description: '10-point grading scale',
        maxGPA: 10
      }
    }
  ];

  console.log('📚 Creating colleges...');
  
  // Check if colleges already exist
  const existingColleges = await prisma.college.findMany();
  
  if (existingColleges.length === 0) {
    for (const college of colleges) {
      const created = await prisma.college.create({
        data: college,
      });
      console.log(`  ✅ ${created.name}`);
    }
  } else {
    console.log('  ℹ️  Colleges already exist, skipping creation');
  }

  // Get all colleges to add grades
  const allColleges = await prisma.college.findMany();

  // Add 10-point grading system grades
  const tenPointGrades = [
    { gradeLetter: 'O', gradePoint: 10, minPercentage: 90, maxPercentage: 100 },
    { gradeLetter: 'A+', gradePoint: 9, minPercentage: 80, maxPercentage: 89 },
    { gradeLetter: 'A', gradePoint: 8, minPercentage: 70, maxPercentage: 79 },
    { gradeLetter: 'B+', gradePoint: 7, minPercentage: 60, maxPercentage: 69 },
    { gradeLetter: 'B', gradePoint: 6, minPercentage: 50, maxPercentage: 59 },
    { gradeLetter: 'C', gradePoint: 5, minPercentage: 40, maxPercentage: 49 },
    { gradeLetter: 'P', gradePoint: 4, minPercentage: 35, maxPercentage: 39 },
    { gradeLetter: 'F', gradePoint: 0, minPercentage: 0, maxPercentage: 34 },
  ];

  // Add 4-point grading system grades
  const fourPointGrades = [
    { gradeLetter: 'A', gradePoint: 4.0, minPercentage: 90, maxPercentage: 100 },
    { gradeLetter: 'A-', gradePoint: 3.7, minPercentage: 85, maxPercentage: 89 },
    { gradeLetter: 'B+', gradePoint: 3.3, minPercentage: 80, maxPercentage: 84 },
    { gradeLetter: 'B', gradePoint: 3.0, minPercentage: 75, maxPercentage: 79 },
    { gradeLetter: 'B-', gradePoint: 2.7, minPercentage: 70, maxPercentage: 74 },
    { gradeLetter: 'C+', gradePoint: 2.3, minPercentage: 65, maxPercentage: 69 },
    { gradeLetter: 'C', gradePoint: 2.0, minPercentage: 60, maxPercentage: 64 },
    { gradeLetter: 'C-', gradePoint: 1.7, minPercentage: 55, maxPercentage: 59 },
    { gradeLetter: 'D', gradePoint: 1.0, minPercentage: 50, maxPercentage: 54 },
    { gradeLetter: 'F', gradePoint: 0.0, minPercentage: 0, maxPercentage: 49 },
  ];

  console.log('📊 Adding grading scales...');
  for (const college of allColleges) {
    if (college.gradingScale === 'TEN_POINT') {
      for (const grade of tenPointGrades) {
        await prisma.grade.upsert({
          where: {
            collegeId_gradeLetter: {
              collegeId: college.id,
              gradeLetter: grade.gradeLetter,
            },
          },
          update: {},
          create: {
            collegeId: college.id,
            ...grade,
          },
        });
      }
      console.log(`  ✅ ${college.name} - 10-point scale added`);
    } else if (college.gradingScale === 'FOUR_POINT') {
      for (const grade of fourPointGrades) {
        await prisma.grade.upsert({
          where: {
            collegeId_gradeLetter: {
              collegeId: college.id,
              gradeLetter: grade.gradeLetter,
            },
          },
          update: {},
          create: {
            collegeId: college.id,
            ...grade,
          },
        });
      }
      console.log(`  ✅ ${college.name} - 4-point scale added`);
    }
  }

  console.log('✨ Database seeding completed successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
