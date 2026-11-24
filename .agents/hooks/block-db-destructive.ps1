# Block Database Destructive Operations Hook
# Reads tool call JSON from stdin and blocks DELETE, DROP, TRUNCATE, and direct DB access.

$input = [Console]::In.ReadToEnd()
$payload = $input | ConvertFrom-Json

$commandLine = ""
if ($payload.toolCall -and $payload.toolCall.args) {
    $commandLine = $payload.toolCall.args.CommandLine
    if (-not $commandLine) { $commandLine = "" }
}

$commandLower = $commandLine.ToLower().Trim()

# Patterns for destructive database operations
$dbPatterns = @(
    'delete\s+from',
    'drop\s+table',
    'drop\s+database',
    'drop\s+schema',
    'drop\s+index',
    'truncate\s',
    'truncate$',
    'prisma\s+migrate\s+reset',
    'prisma\s+db\s+push\s+--force-reset',
    'prisma\s+migrate\s+dev',
    'prisma\s+migrate\s+deploy',
    'prisma\s+db\s+seed',
    'prisma\s+db\s+push',
    'psql\s',
    'mysql\s',
    'sqlite3\s',
    'mongosh\s',
    'mongo\s',
    'redis-cli\s.*\bflushall\b',
    'redis-cli\s.*\bflushdb\b',
    'redis-cli\s.*\bdel\b'
)

$blocked = $false
$matchedPattern = ""
foreach ($pattern in $dbPatterns) {
    if ($commandLower -match $pattern) {
        $blocked = $true
        $matchedPattern = $pattern
        break
    }
}

if ($blocked) {
    $result = @{
        decision = "deny"
        reason = "GUARDRAIL VIOLATION (Rule 3): Database destructive operations are forbidden. Do not touch the database directly without the user's explicit instruction. Matched pattern: $matchedPattern. Present the exact command to the user and let them execute it."
    }
} else {
    $result = @{
        decision = "allow"
    }
}

$result | ConvertTo-Json -Compress
