// Conditionally load dotenv only if available (for local development)
// On Render, environment variables are already injected
try {
  await import("dotenv/config");
} catch (e) {
  // dotenv not available, assume env vars are already set (production)
}

import { defineConfig } from "prisma/config";

export default defineConfig({
  engine: "classic",
  datasource: {
    url: process.env.DATABASE_URL,
  },
});
