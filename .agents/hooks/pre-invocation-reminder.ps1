# Pre-Invocation Reminder Hook
# Reminds model before every turn of zero-trust constraints.

$reminder = "ZERO-TRUST ACTIVE: Present plan first and await user 'OK' / 'Go'. No git, no delete, no secrets access, no outbound network."

@{
    injectSteps = @(
        @{
            systemMessage = @{
                systemMessage = $reminder
            }
        }
    )
} | ConvertTo-Json -Depth 5 -Compress
