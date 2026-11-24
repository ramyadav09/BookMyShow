# 🛡️ Universal Zero-Trust Multi-Agent Starter Template

> **A reusable, stack-agnostic AI agent governance template.**  
> Drop this `.agents/` folder and `AGENTS.md` into **any** project, regardless of language, framework, or database.

---

## 🚀 How to Use in Any New Project

1. **Copy the Template Files into your new project root:**
   ```text
   YourProject/
   ├── .agents/          # Copy entire folder
   ├── AGENTS.md         # Copy root entrypoint
   └── README.md         # Customize with your project details
   ```
2. **Configure Your Stack in [`AGENTS.md`](./AGENTS.md):**
   - Open `AGENTS.md`.
   - Fill in **Section 1 (Project Identity)**: Name, Type, Language/Runtime.
   - Fill in **Section 2 (Tech Stack Definition)**: Choose your Frontend, Backend, Database, Auth, and Testing tools.
3. **That's it!** All AI agents (Antigravity, Claude, Cursor, Copilot, Gemini, Windsurf, Cline, etc.) will immediately adopt the zero-trust guardrails and your specific tech stack.

---

## 🔒 Built-in Zero-Trust Security Features

| Feature | How It Works |
|---|---|
| **Plan-First Approval Gate** | Agents must present a complete plan and wait for your explicit **"OK"** or **"Go"** before executing anything. |
| **Git Read-Only Whitelist** | Agents can run `git status`, `git diff`, `git log` to inspect code, but all writes (`commit`, `push`, `reset`, `checkout`, `gh`) are hard-blocked. |
| **Destructive Operation Lock** | File deletions (`rm`, `del`) and database wipes (`DROP`, `DELETE`, `TRUNCATE`) are strictly blocked. |
| **Network Isolation with Timed Lease** | Outbound network calls are blocked by default. Run `.agents/hooks/unlock-network.ps1 -Minutes 5` when temporary access is needed. |
| **Secrets Protection** | Reading or modifying `.env` and credential keys is blocked. |
| **Shell Command Gate** | Every terminal execution triggers a `force_ask` confirmation prompt. |

---

## 📁 Repository Structure

```text
├── .agents/                               # AI agent rules, hooks & adapters
│   ├── guardrails.md                      # Security, approval gates, destructive-op locks
│   ├── response-style.md                  # Communication & formatting preferences
│   ├── hooks.json                         # Deterministic PreToolUse & lifecycle hooks
│   ├── hooks/                             # Hook enforcement scripts (PowerShell)
│   │   ├── block-git-and-gh.ps1           # Enforces Git read-only whitelist
│   │   ├── block-destructive-ops.ps1      # Blocks file/DB deletions
│   │   ├── block-network.ps1              # Enforces network isolation + timed lease
│   │   ├── unlock-network.ps1             # Helper to grant temporary network lease
│   │   ├── block-secrets-access.ps1       # Blocks CLI secret inspection
│   │   ├── block-secrets-file-write.ps1   # Blocks editing live .env files
│   │   ├── block-outside-project.ps1      # Dynamically confines actions to repo root
│   │   ├── block-all-commands.ps1         # Force-ask gate on all shell executions
│   │   ├── session-reminder.ps1           # Session start reminder
│   │   └── pre-invocation-reminder.ps1    # Per-turn reminder
│   └── adapters/                          # 11 Agent-specific wrappers
├── AGENTS.md                              # ⬅ Single root entrypoint for all agents
└── README.md                              # Project documentation
```

---

## 🛡️ Active Hook Cheatsheet

- **Check git status:** `git status` *(allowed for agents)*
- **Make commits / push:** Run manually in your terminal *(agents cannot push)*
- **Install packages (needs network):** Run `.agents/hooks/unlock-network.ps1 -Minutes 10` before installing dependencies.

---

*Universal Zero-Trust Multi-Agent Starter Template*
