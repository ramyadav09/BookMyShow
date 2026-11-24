# Block File Deletion Hook
# Reads tool call JSON from stdin and blocks any file/directory deletion command.

$input = [Console]::In.ReadToEnd()
$payload = $input | ConvertFrom-Json

$commandLine = ""
if ($payload.toolCall -and $payload.toolCall.args) {
    $commandLine = $payload.toolCall.args.CommandLine
    if (-not $commandLine) { $commandLine = "" }
}

$commandLower = $commandLine.ToLower().Trim()

# Patterns that delete files or directories
$deletePatterns = @(
    '(^|\s|;|&&|\|)rm\s',
    '(^|\s|;|&&|\|)rm$',
    '(^|\s|;|&&|\|)rmdir\s',
    '(^|\s|;|&&|\|)del\s',
    '(^|\s|;|&&|\|)del$',
    '(^|\s|;|&&|\|)erase\s',
    'remove-item',
    'ri\s+-',
    '(^|\s|;|&&|\|)rd\s',
    '(^|\s|;|&&|\|)rd$',
    'shutil\.rmtree',
    'os\.remove',
    'os\.unlink',
    'fs\.unlink',
    'fs\.rm',
    'rimraf',
    'del\s+/s',
    'del\s+/q'
)

$blocked = $false
foreach ($pattern in $deletePatterns) {
    if ($commandLower -match $pattern) {
        $blocked = $true
        break
    }
}

if ($blocked) {
    $result = @{
        decision = "deny"
        reason = "GUARDRAIL VIOLATION (Rule 4): File deletion is forbidden. No agent may delete any file or directory. If a file is no longer needed, tell the user and let them delete it manually."
    }
} else {
    $result = @{
        decision = "allow"
    }
}

$result | ConvertTo-Json -Compress
