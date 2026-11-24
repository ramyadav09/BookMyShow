# Block Destructive Operations Hook
# Hard-deny file deletion, destructive DB operations, and publishing.

$inputContent = [Console]::In.ReadToEnd()
if (-not $inputContent) {
    @{ decision = "allow" } | ConvertTo-Json -Compress
    exit 0
}

try {
    $payload = $inputContent | ConvertFrom-Json
} catch {
    @{ decision = "allow" } | ConvertTo-Json -Compress
    exit 0
}

$commandLine = ""
if ($payload.toolCall -and $payload.toolCall.args -and $payload.toolCall.args.CommandLine) {
    $commandLine = [string]$payload.toolCall.args.CommandLine
}

$commandLower = $commandLine.ToLower().Trim()

$destructivePatterns = @(
    # File / directory deletion
    '(^|[\s;&|])rm([\s;&|]|$)',
    '(^|[\s;&|])rmdir([\s;&|]|$)',
    '(^|[\s;&|])del([\s;&|]|$)',
    '(^|[\s;&|])erase([\s;&|]|$)',
    '(^|[\s;&|])remove-item([\s;&|]|$)',
    '(^|[\s;&|])ri([\s;&|]|$)',
    '(^|[\s;&|])rd([\s;&|]|$)',
    'shutil\.rmtree',
    'os\.remove',
    'os\.unlink',
    'fs\.unlink',
    'fs\.rm',
    'rimraf',
    # Database destructive operations & direct shell access
    'delete\s+from',
    'drop\s+table',
    'drop\s+database',
    'drop\s+schema',
    'drop\s+index',
    'truncate\s',
    'truncate$',
    'prisma\s+migrate\s+reset',
    'prisma\s+db\s+push\s+--force-reset',
    '(^|[\s;&|])psql([\s;&|]|$)',
    '(^|[\s;&|])mysql([\s;&|]|$)',
    '(^|[\s;&|])sqlite3([\s;&|]|$)',
    '(^|[\s;&|])mongosh([\s;&|]|$)',
    '(^|[\s;&|])mongo([\s;&|]|$)',
    'redis-cli\s+.*\bflushall\b',
    'redis-cli\s+.*\bflushdb\b',
    'redis-cli\s+.*\bdel\b',
    # Registry publishing / unapproved deploy
    'npm\s+publish',
    'pnpm\s+publish',
    'yarn\s+publish',
    'docker\s+push',
    'docker\s+system\s+prune'
)

$blocked = $false
$matchedPattern = ""
foreach ($pattern in $destructivePatterns) {
    if ($commandLower -match $pattern) {
        $blocked = $true
        $matchedPattern = $pattern
        break
    }
}

if ($blocked) {
    @{
        decision = "deny"
        reason   = "ZERO-TRUST VIOLATION (Rules 3, 4 - Destructive Lock): Destructive operations (file deletion, direct DB mutations/shells, package publishing) are forbidden. Matched pattern: '$matchedPattern'."
    } | ConvertTo-Json -Compress
} else {
    @{ decision = "allow" } | ConvertTo-Json -Compress
}
