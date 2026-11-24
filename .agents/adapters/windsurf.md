# Windsurf — Agent Rules

> Instructions for the Windsurf (Codeium) agent in this repository.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Cascade and autonomous workflows must **NEVER** execute actions automatically. Always present a complete plan and wait for explicit user consent ("OK" or "Go").

## Mandatory References
1. [`AGENTS.md`](../../AGENTS.md) — Stack definition and architecture
2. [`.agents/guardrails.md`](../guardrails.md) — Security guardrails and hooks
3. [`.agents/response-style.md`](../response-style.md) — Coding conventions

## Core Restrictions
- Read-only Git is allowed; mutating git and `gh` CLI commands are strictly forbidden.
- Never delete files or database tables/records.
- Keep the workspace isolated: no unapproved outbound network calls, stay inside the project root.
- Never read or modify `.env` or secret credential files.
