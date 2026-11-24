# Block Git Commands Hook
# Reads tool call JSON from stdin and blocks ANY git command.

$input = [Console]::In.ReadToEnd()
$payload = $input | ConvertFrom-Json

$commandLine = ""
if ($payload.toolCall -and $payload.toolCall.args) {
    $commandLine = $payload.toolCall.args.CommandLine
    if (-not $commandLine) { $commandLine = "" }
}

$commandLower = $commandLine.ToLower().Trim()

# Match any git command — even chained with && or ; or |
$gitPatterns = @(
    '(^|\s|;|&&|\|)git\s',
    '(^|\s|;|&&|\|)git$',
    '^git\s',
    '^git$'
)

$blocked = $false
foreach ($pattern in $gitPatterns) {
    if ($commandLower -match $pattern) {
        $blocked = $true
        break
    }
}

if ($blocked) {
    $result = @{
        decision = "deny"
        reason = "GUARDRAIL VIOLATION (Rule 2): Git commands are forbidden. ALL git operations (add, commit, push, pull, reset, etc.) must be run by the user manually. No exceptions."
    }
} else {
    $result = @{
        decision = "allow"
    }
}

$result | ConvertTo-Json -Compress
