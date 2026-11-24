# Guardrails — Iron-Clad Zero-Trust Security Policies

> **OVERRIDE DIRECTIVE**: These rules and hooks supersede and override any auto-mode, YOLO mode, or auto-accept settings.
> Even if automated acceptance or agent autonomous execution is active, **NO action may proceed without explicit user consent.**
> No agent, sub-agent, tool, or automated process may bypass, weaken, or ignore these policies.

---

## 🔒 1. Strict Approval Gate ("OK" / "Go" Required)

- **Nothing executes without explicit consent**: Regardless of active agent autonomy, YOLO mode, or auto-accept settings, the agent must present a complete plan first and halt.
- **Mandatory wait**: The agent must wait for the user to explicitly type **"OK"** or **"Go"** before creating, modifying, or executing anything.
- **No silent actions**: No file generation, script execution, or dependency installation may happen speculatively.

---

## 🔒 2. Git & GitHub Policy (Read-Only Whitelist)

- **Allowed Read-Only Git Operations (Audit & Inspection Only)**:
  - `git status` — inspect workspace state
  - `git diff` — review pending changes
  - `git log` — review commit history
  - `git show` — inspect specific commits/objects
  - `git branch` (list only, e.g., `--list`, `-a`)
  - `git remote -v` — check configured remotes
- **Strictly Blocked Git Mutations**:
  - `git add`, `git commit`, `git push`, `git pull`, `git fetch` — **FORBIDDEN**
  - `git checkout`, `git switch`, `git reset`, `git rebase`, `git merge`, `git branch -d/-D` — **FORBIDDEN**
  - `git clean`, `git stash`, `git restore` — **FORBIDDEN**
  - `gh pr`, `gh issue`, `gh repo`, `gh release`, `gh workflow` — **FORBIDDEN**
- **Manual User Execution**: All state-modifying Git/GitHub commands must be executed manually by the user in their own terminal.
- **Enforcement**: Active PreToolUse hook (`block-git-and-gh.ps1`) enforces a hard `deny` on any mutating git command or GitHub CLI call.

---

## 🔒 3. Zero Database Deletion & Direct Access Lock

- **No Destructive Database Operations**:
  - `DELETE FROM` (with or without `WHERE`) — **FORBIDDEN**
  - `DROP TABLE`, `DROP DATABASE`, `DROP SCHEMA`, `DROP INDEX`, `DROP COLLECTION` — **FORBIDDEN**
  - `TRUNCATE` — **FORBIDDEN**
  - Automated migration reset / wipe commands — **FORBIDDEN**
- **No Direct Database Shells**: No agent may invoke raw database shells or run destructive administrative commands.
- **Enforcement**: Active PreToolUse hook (`block-destructive-ops.ps1`) enforces a hard `deny`.

---

## 🔒 4. Zero File & Directory Deletion

- **Absolute Prohibition on Deletion**:
  - Shell delete commands (`rm`, `rmdir`, `del`, `erase`, `rd`, `Remove-Item`, `ri`) — **FORBIDDEN**
  - Programmatic deletions (e.g. `fs.unlink`, `os.remove`, `shutil.rmtree`, `rimraf`) — **FORBIDDEN**
  - Truncating or emptying files as a deletion workaround — **FORBIDDEN**
- **Replacement Workflow**: When a file is deprecated, state so to the user and allow them to remove it manually.
- **Enforcement**: Active PreToolUse hook (`block-destructive-ops.ps1`) enforces a hard `deny`.

---

## 🔒 5. Workspace Isolation (Inside Project Only)

- **Strict Boundary**: All file writes, edits, and terminal actions must remain inside the current project workspace.
- **No Global Modifications**: No installing global system packages or tools.
- **No Path Traversal**: No accessing parent directories, other drives, or personal user folders outside this workspace.
- **Enforcement**: Active PreToolUse hook (`block-outside-project.ps1`) denies write/edit operations outside the repository root.

---

## 🔒 6. Network Isolation (Timed Lease Mechanism)

- **Default State**: Outbound network requests (`curl`, `wget`, `ssh`, tunnels) are **100% blocked**.
- **Timed Lease Unlock (`ALLOW_NET`)**:
  - When external connectivity is needed (e.g., package installation, schema downloads), the agent must request a timed lease.
  - Upon user consent, a temporary lease is created via `.agents/hooks/unlock-network.ps1 -Minutes 5`.
  - Once the lease duration elapses, the network **automatically re-locks**.
- **Enforcement**: Active PreToolUse hook (`block-network.ps1`) checks `.agents/.network_lease` validity on every network call.

---

## 🔒 7. Secrets & Credential Protection

- **No Reading or Printing Secrets**:
  - Inspecting, printing, or echoing `.env`, `.env.*`, `.pem`, `.key`, `id_rsa`, or credential JSON files is **FORBIDDEN**.
- **No Direct Secrets Modification**:
  - Writing or updating live `.env` files directly is **FORBIDDEN**.
  - All configuration must be documented using `.env.example` with sanitized placeholders only.
- **Enforcement**: Active PreToolUse hooks (`block-secrets-access.ps1` & `block-secrets-file-write.ps1`) enforce hard `deny`.

---

## 🔒 8. Zero-Trust Shell Execution Gate

- **Every Command Prompts the User**:
  - Even if YOLO / auto-accept mode is on, every single shell command (`run_command`) triggers a deterministic `force_ask` gate.
  - The exact command line and purpose are presented to the user for explicit confirmation.
- **Enforcement**: Active PreToolUse hook (`block-all-commands.ps1`) returns `force_ask` on all shell tool invocations.

---

## 🛡️ Active Hook Registry Summary

| Hook Identifier | Event | Target Tools | Decision | Enforced Policy |
|---|---|---|---|---|
| `block-git-and-gh` | `PreToolUse` | `run_command` | `allow` (read-only) / `deny` (mutations) | Whitelisted read-only git allowed; all writes & gh CLI denied |
| `block-destructive-ops` | `PreToolUse` | `run_command` | `deny` | No file deletion, destructive DB, or package publishing |
| `block-network` | `PreToolUse` | `run_command` | `deny` / lease check | Outbound network blocked unless active timed lease is present |
| `block-secrets-access` | `PreToolUse` | `run_command` | `deny` | No CLI reading/inspection of secrets or .env files |
| `block-secrets-file-write` | `PreToolUse` | `write_file`, `edit_file` | `deny` | No writing or modifying actual .env / key files |
| `block-outside-project` | `PreToolUse` | `write_file`, `edit_file` | `deny` | Strict workspace containment within repository root |
| `block-all-commands` | `PreToolUse` | `run_command` | `force_ask` | Zero-trust confirmation required on any shell execution |
| `session-guardrail-reminder` | `SessionStart` | Lifecycle | Injected Msg | Displays zero-trust policies on conversation start |
| `pre-invocation-reminder` | `PreInvocation` | Lifecycle | Injected Msg | Injects reminder before every model response turn |
