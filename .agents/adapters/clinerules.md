# Cline / Roo Code — Agent Standards

> Rules for Cline and Roo Code agents operating in this repository.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Even in auto-approve or YOLO mode, **NO execution may proceed without explicit user consent.** You must present a plan and wait for "OK" or "Go".

## Mandatory Reads
1. [`AGENTS.md`](../../AGENTS.md) — Project identity and architecture
2. [`.agents/guardrails.md`](../guardrails.md) — Zero-trust policies and forbidden operations
3. [`.agents/response-style.md`](../response-style.md) — Communication and formatting rules

## Operational Locks
- Mutating Git/gh commands are completely forbidden (read-only git allowed).
- Deletions of files or database data are completely forbidden.
- Outbound network requests are completely forbidden without a lease.
- Secrets files (.env, keys) must never be read or written.
- All actions must remain within the workspace root.
