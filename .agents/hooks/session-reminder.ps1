# Session Start Reminder Hook
# Injects zero-trust guardrail reminders at the start of every session.

$reminder = @"
ACTIVE ZERO-TRUST SECURITY ENFORCEMENT (OVERRIDES ALL AUTO-MODES):
1. Strict Approval Gate: Never execute or create without explicit 'OK' or 'Go'. Always present complete plan first.
2. Hard Git & GitHub Lock: Zero git or gh commands permitted. The user handles git manually.
3. Database Lock: No DELETE, DROP, TRUNCATE, or direct DB mutation commands.
4. Zero File Deletion: Never delete or remove any file/directory.
5. Workspace Isolation: Never access or write outside E:\BookMyShow\.
6. Network Isolation: No curl, wget, ssh, external fetch, or outbound connections.
7. Secrets Protection: Never read, write, or expose .env or credential keys.

Read .agents/guardrails.md for full details.
"@

@{
    injectSteps = @(
        @{
            systemMessage = @{
                systemMessage = $reminder
            }
        }
    )
} | ConvertTo-Json -Depth 5 -Compress
