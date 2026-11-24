# Serverless & Edge Functions (Cloudflare Workers / Netlify & Vercel)

All engineering rules from `engineering.md` apply. This adds constraints and practices specific to serverless architectures, edge runtimes, and stateless microservices.

## Architecture & Frameworks

- **Stateless Design:** All logic must be strictly stateless. Do not use local server memory variables (`let cache = {}`) to store persistent session states or transaction logs across invocations.
- **Runtime Target Awareness:** Always verify the target runtime environment. For Cloudflare Workers and Vercel/Netlify Edge, write V8-compatible code. Never use Node.js native APIs (e.g., `fs`, `crypto`, `path`) unless the `nodejs_compat` configuration flag is explicitly set.
- **I/O Chaining:** Chain asynchronous tasks cleanly using `event.waitUntil()` (in Cloudflare) to process logs, metrics, or analytics in the background. Do not hold up the main HTTP response thread.

## Performance & Resource Management

- **10ms CPU Gatekeeping:** When deploying to Cloudflare Workers Free, minimize heavy synchronous computation (like complex JSON parsing or massive array sorting) to prevent "Exceeded CPU time limit" exceptions.
- **Tree-Shaking Dependencies:** Keep the final deployment bundle under the limits (3MB for Cloudflare, 50MB for Netlify). Import specific sub-modules natively (`import { S3Client } from "@aws-sdk/client-s3"`) instead of pulling in entire massive SDK wrapper trees.
- **Connection Re-use:** Declare heavy client initializers (such as Prisma/Neon DB clients or Redis connection pools) globally outside the main request handler function to leverage execution context recycling across warm starts.

## Data Fetching & Security

- **Subrequest Ceilings:** Keep total outbound API fetches per invocation below 50 when writing Cloudflare Workers to prevent execution aborts.
- **Environment Isolation:** Secrets, API keys, and connection strings must never be hardcoded or checked into repository trees. Access them cleanly via injected environment bindings (`env.DATABASE_URL` or `process.env`).
- **Graceful Error Resilience:** All third-party outbound requests must run inside an explicit `try/catch` wrapper block. Fallback mechanisms must trigger explicitly, and runtime catch states must never fail silently.

## Response & Payload Safety

- **Streaming by Default:** For heavy payloads or data pipelines, prefer streaming chunked transfers (`ReadableStream`) over bulk memory buffering.
- **Payload Limits:** Ensure request and response bodies stay well below platform strict boundaries (e.g., Vercel's 4.5MB limitation) to avoid "413 Payload Too Large" API rejections.
- **CORS Management:** Configure explicit Cross-Origin Resource Sharing rules dynamically inside header configuration maps. Never default to wildcard origins (`Access-Control-Allow-Origin: *`) on routes handling private data structures.
