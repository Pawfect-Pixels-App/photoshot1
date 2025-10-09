import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

declare global {
  var db: PrismaClient | undefined;
}

const db = globalThis.db || prisma;

if (process.env.NODE_ENV !== "production") {
  globalThis.db = db;
}

export default db;

async function getUsers() {
  return await prisma.user.findMany();
}

// Example usage:
// getUsers().then(users => console.log(users));
