/// <reference types="node" />

export default {
  client: {
    provider: "prisma-client-js",
  },
  datasource: {
    provider: "postgresql",
    url: process.env.DATABASE_URL,
  },
};
