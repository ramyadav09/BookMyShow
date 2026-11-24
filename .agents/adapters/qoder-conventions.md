# Qoder — Agent Conventions

> Rules and conventions for Qoder working in this repository.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Autonomous actions must **NEVER** run speculatively. Always present a plan and await explicit user approval ("OK" or "Go").

## Mandatory Reads
1. [`AGENTS.md`](../../AGENTS.md) — Architecture and conventions
2. [`.agents/guardrails.md`](../guardrails.md) — Security guardrails
3. [`.agents/response-style.md`](../response-style.md) — Output standards

## Critical Locks
- Strictly no mutating `git` or `gh` commands.
- Zero file deletions and zero database deletions.
- No outbound network connections without a timed lease.
- No reading, displaying, or modifying `.env` or secrets.
- All actions stay strictly inside the workspace root.
