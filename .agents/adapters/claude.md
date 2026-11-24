# Claude Code — Agent Instructions

> Place this file at `.agents/adapters/claude.md` or symlink to `.claude/instructions.md`.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Regardless of autonomous mode or auto-accept permissions, **NO action or command execution may proceed without explicit user consent.** You must present a clear plan and await user approval ("OK" or "Go").

## Mandatory Reading Order
1. [`AGENTS.md`](../../AGENTS.md) — Project identity, tech stack, and conventions
2. [`.agents/guardrails.md`](../guardrails.md) — Zero-trust policies and forbidden operations
3. [`.agents/response-style.md`](../response-style.md) — Communication and formatting rules

## Inviolable Security Restrictions
- **Zero Git Mutations**: Never execute mutating `git` or `gh` commands. Read-only inspection is permitted.
- **Zero Deletion**: Never delete files or database tables/records.
- **Network Isolation**: Outbound calls (`curl`, `wget`, `ssh`) are strictly blocked without a timed lease.
- **Secrets Protection**: Never inspect or edit live `.env` files.
- **Workspace Boundary**: Confine all file changes strictly inside the workspace.
