# {{PROJECT_NAME}} — Agent Playbook

> **Single source of truth for every AI coding agent working in this repository.**
> All shared rules, guardrails, and skills live in [`.agents/`](.agents/) — read them before writing any code.

---

## 1. Project Identity

| Field | Value | Notes |
|---|---|---|
| **Project Name** | `{{PROJECT_NAME}}` | *Replace with your project title* |
| **Project Type** | `{{PROJECT_TYPE}}` | *(e.g. Web App, Monorepo, Microservice, Mobile, CLI)* |
| **Repository Status** | Greenfield / In-Development | *Update as project matures* |
| **Primary Language & Runtime** | `{{PRIMARY_LANGUAGE_AND_RUNTIME}}` | *(e.g. TypeScript / Python / Go / Rust)* |
| **Package / Dependency Manager** | `{{PACKAGE_MANAGER}}` | *(e.g. pnpm / npm / poetry / uv / cargo)* |
| **License** | `{{LICENSE}}` | *(e.g. MIT / Apache 2.0 / Proprietary)* |

---

## 2. Tech Stack Definition

*Configure the chosen architecture for this project below:*

| Architectural Layer | Technology Choice | Rationale & Guidelines |
|---|---|---|
| **Client / Frontend** | `[Define UI Framework / Library]` | *(e.g. React, Next.js, React Native, Vue, Svelte)* |
| **Server / API** | `[Define Backend Runtime / Framework]` | *(e.g. FastAPI, Node Express/Nest, Go Gin, Serverless)* |
| **Persistence / Database** | `[Define Primary Database & ORM]` | *(e.g. PostgreSQL, SQLite, Prisma, SQLAlchemy)* |
| **Caching & In-Memory** | `[Define Caching & State Store]` | *(e.g. Redis, Memcached, In-Memory)* |
| **Authentication & AuthZ** | `[Define Auth Strategy]` | *(e.g. JWT, OAuth, Session, API Keys)* |
| **Testing Strategy** | `[Define Test Frameworks]` | *(e.g. Unit tests, Integration, E2E)* |
| **Infra & Deployment** | `[Define Infrastructure]` | *(e.g. Docker, Serverless, Cloudflare, AWS)* |

---

## 3. Skills Library (`.agents/skills/`)

Load the relevant skill before touching corresponding project layers:

| Skill | Path | Scope & Purpose |
|---|---|---|
| **Core Engineering** | [`.agents/skills/engineering.md`](.agents/skills/engineering.md) | **Foundation:** Inspect before coding, reuse patterns, verify before claiming done. (Applies to all changes). |
| **Project Bootstrap** | [`.agents/skills/project-bootstrap.md`](.agents/skills/project-bootstrap.md) | Generates planning docs (PRD, Architecture, Database, API, Plan) before implementation begins. |
| **Testing Strategy** | [`.agents/skills/testing-strategy.md`](.agents/skills/testing-strategy.md) | Testing pyramid, unit/integration/E2E isolation, mock data strategies. |
| **API & Interface Design** | [`.agents/skills/api-design.md`](.agents/skills/api-design.md) | REST/RPC standards, RFC 7807 error responses, idempotency keys, rate-limiting. |
| **Security Hardening** | [`.agents/skills/security-hardening.md`](.agents/skills/security-hardening.md) | OWASP defenses, input sanitization, BOLA/IDOR prevention, auth hardening. |
| **Frontend Design** | [`.agents/skills/design.md`](.agents/skills/design.md) | Distinctive, non-generic visual design, typography, spacing, and micro-interactions. |
| **React** | [`.agents/skills/react.md`](.agents/skills/react.md) | Clean React patterns, hooks, state management, and component architecture. |
| **Next.js** | [`.agents/skills/nextjs.md`](.agents/skills/nextjs.md) | App Router, Server Components, caching, server actions, and route handlers. |
| **React Native** | [`.agents/skills/react-native.md`](.agents/skills/react-native.md) | Mobile development, navigation, native modules, responsive layouts. |
| **FastAPI** | [`.agents/skills/fastapi.md`](.agents/skills/fastapi.md) | Python backend, Pydantic schemas, dependency injection, async endpoints. |
| **Database** | [`.agents/skills/database.md`](.agents/skills/database.md) | Schema design, indexing, migrations, query performance (SQL/NoSQL). |
| **Serverless** | [`.agents/skills/serverless.md`](.agents/skills/serverless.md) | Edge functions, Cloudflare Workers, Lambda, cold-start optimization. |

*Read multiple skills when a change spans layers (e.g., frontend design + React + API).*

---

## 4. Architecture Decision Records (ADRs)

All non-trivial technical and architectural decisions must be documented in [`docs/adr/`](docs/adr/):

- **Template**: Use [`docs/adr/template.md`](docs/adr/template.md) for new records (`NNNN-short-title.md`).
- **Review**: Propose decisions via ADR pull requests before landing large architectural refactors.

---

## 5. Zero-Trust Security & Execution Model

This repository enforces a strict, deterministic zero-trust governance model:

- **Plan-First Approval**: Every agent must formulate and present a complete plan before touching code, creating files, or executing commands. Wait for explicit user **"OK"** or **"Go"**.
- **Git Policy (Read-Only Whitelist)**:
  - Allowed: `git status`, `git diff`, `git log`, `git show`, `git branch` (list), `git remote -v`
  - Hard-Blocked: `git add`, `git commit`, `git push`, `git reset`, `git checkout`, `gh` CLI. All write operations are performed manually by the user.
- **Network Isolation (Timed Lease)**:
  - Default: 100% blocked (no `curl`, `wget`, `ssh`, tunnels).
  - Temporary unlock: Time-limited lease via `.agents/hooks/unlock-network.ps1 -Minutes 5` upon user permission.
- **Secrets Protection & Leak Scanning**:
  - Live `.env` and credential files are strictly protected from read/write tools.
  - Active hook `scan-secrets.ps1` blocks any code write containing live API keys or tokens.
- **Audit Logging**: All tool executions are recorded in `.agents/logs/audit.log`.
- **Deterministic PreToolUse Hooks**: Configured in `.agents/hooks.json` to enforce these rules at runtime.

---

## 6. Repository Layout (Convention)

```text
{{PROJECT_NAME}}/
├── .agents/                     # AI agent rules, hooks, adapters & skills
│   ├── guardrails.md            # Security, approval gates, destructive-op locks
│   ├── response-style.md        # Communication & formatting preferences
│   ├── hooks.json               # Deterministic PreToolUse & lifecycle hooks
│   ├── hooks/                   # Hook enforcement scripts
│   ├── adapters/                # Per-agent adapter files
│   └── skills/                  # Domain, stack & engineering skills
├── apps/ or src/                # Application source code
├── packages/ or libs/           # Shared libraries or packages
├── docs/                        # Architecture Decision Records (ADRs) & specs
│   └── adr/                     # Markdown ADRs (0000-..., 0001-...)
├── tests/                       # Test suites & fixtures
├── AGENTS.md                    # ⬅ THIS FILE — root entrypoint
└── README.md                    # Developer-facing project documentation
```

---

## 7. Mandatory Reads (In Order)

Every agent **must** read these files before writing or modifying any code:

1. **[`.agents/guardrails.md`](.agents/guardrails.md)** — Security policies, forbidden operations, approval gates
2. **[`.agents/response-style.md`](.agents/response-style.md)** — Output format, tone, and documentation standards
3. **Relevant Skill in [`.agents/skills/`](.agents/skills/)** — Stack-specific guidelines for the task at hand
4. **Your adapter file** in [`.agents/adapters/`](.agents/adapters/) — Agent-specific translation of the above rules

---

*Universal Multi-Agent Template — Ready for Project Customization*
