# Amazon Q Developer — Agent Standards

> Checklist and instructions for Amazon Q Developer working in this repository.

## ⚠️ ZERO-TRUST SECURITY DIRECTIVE (OVERRIDES AUTO-ACCEPT / YOLO)

Regardless of autonomy or auto-accept mode, **NO code generation or command execution may proceed without explicit user consent.** You must present a plan and wait for "OK" or "Go".

## Pre-Flight Checklist
- [ ] Explicit user consent ("OK" / "Go") obtained for the current task
- [ ] Target architecture matches definition in `AGENTS.md`
- [ ] No mutating `git` or `gh` commands invoked (read-only allowed)
- [ ] No destructive file or database deletion operations
- [ ] No unapproved outbound network calls made (`curl`, `wget`, `ssh`)
- [ ] No `.env` or credential secrets accessed or printed
- [ ] All file changes confined to workspace root
- [ ] Follows all rules in `.agents/guardrails.md`
