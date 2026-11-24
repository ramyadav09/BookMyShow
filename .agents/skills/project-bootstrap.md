# Project Bootstrap

Generate planning documents from a project idea, once, before any implementation.

## Trigger

When the user has a project idea markdown file and asks to initialize / bootstrap / scaffold the project.

## Workflow

1. **Read the idea file.** Understand what the project does, who it's for, and the core problem it solves. Ask clarifying questions only if the idea is genuinely ambiguous — not for nice-to-haves.
2. **Read `skills/engineering.md`.** The generated docs must follow the same philosophy: minimal, no speculative architecture, no premature optimization.
3. **Determine what docs the project actually needs.** Not every project needs all of these. Generate only what's relevant:

| Doc               | Generate when                                                               |
| ----------------- | --------------------------------------------------------------------------- |
| `PRD.md`          | Always. Scope, users, core features, success criteria.                      |
| `ARCHITECTURE.md` | Always. Tech stack, system components, data flow, key decisions.            |
| `DATABASE.md`     | If the project has persistent data. Schema, relationships, constraints.     |
| `API.md`          | If the project has a backend API. Endpoints, request/response shapes, auth. |
| `PLAN.md`         | Always. Phased implementation order with dependencies.                      |

4. **Generate the docs.** Write them to the project root. One file per doc.
5. **Stop.** Do not start implementing. The bootstrap is done when the planning docs exist and are consistent with each other.

## Document Guidelines

Keep every doc short and opinionated. No speculative sections. No "future considerations" paragraphs. If something isn't in scope, don't mention it.

### PRD.md

- **Problem:** One paragraph. What pain point does this solve?
- **Users:** Who uses this? One or two sentences per role.
- **Core features:** Bulleted list. 5-10 items max. Each feature is one sentence.
- **Success criteria:** How do we know it works? Concrete, measurable outcomes.
- **Out of scope:** What we are explicitly NOT building. Prevents scope creep.

### ARCHITECTURE.md

- **Stack:** List the actual technologies with versions if known. Justify non-obvious choices in one line.
- **System overview:** How the pieces connect. A short description or a simple diagram.
- **Key decisions:** Record 2-5 architectural decisions and _why_ they were made. Not every choice needs recording — only the ones that would surprise someone.
- **Constraints:** Known limitations, scale assumptions, deployment target.

### DATABASE.md

- **Entities:** Tables with columns, types, and constraints. Not a prose description — a schema.
- **Relationships:** How entities connect. Foreign keys, one-to-many, many-to-many.
- **Indexes:** What gets indexed and why (based on expected queries, not hypothetical ones).
- **Migrations strategy:** Which tool, how migrations are managed.

### API.md

- **Base URL and versioning:** Where the API lives, how versions are handled.
- **Auth:** How authentication works. Token type, where it's sent.
- **Endpoints:** Method, path, purpose, request body, response shape, status codes.
- **Error format:** Consistent error response structure.

### PLAN.md

- **Phase N: [Name]** — What gets built. Dependencies on prior phases. "Done" means:
  - [ ] Specific deliverable 1
  - [ ] Specific deliverable 2
- Order phases by dependency, not by preference. Infrastructure first, then core, then features, then polish.

## Rules

- Generate docs from the idea, not from assumptions. If the idea doesn't specify something, leave it out or mark it as a decision point — do not invent it.
- All docs reference each other consistently. If ARCHITECTURE.md says PostgreSQL, DATABASE.md uses PostgreSQL syntax. If API.md defines a `/users` endpoint, DATABASE.md has a `users` table.
- Follow `engineering.md`: no speculative architecture, no premature optimization, no unnecessary abstractions.
- This is a one-time operation. Once the docs exist, the project moves to implementation using the stack-specific skills.
