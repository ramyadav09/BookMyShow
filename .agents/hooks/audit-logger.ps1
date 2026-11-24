# Audit Logger Hook (PostToolUse on all tools)
# Silently appends an audit record to .agents/logs/audit.log

$inputContent = [Console]::In.ReadToEnd()
if (-not $inputContent) {
    @{} | ConvertTo-Json -Compress
    exit 0
}

try {
    $payload = $inputContent | ConvertFrom-Json
} catch {
    @{} | ConvertTo-Json -Compress
    exit 0
}

$logDir = Join-Path $PSScriptRoot "..\logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

$logFile = Join-Path $logDir "audit.log"
$timestamp = [DateTime]::UtcNow.ToString("o")

$toolName = "unknown"
$details = ""

if ($payload.toolCall) {
    $toolName = $payload.toolCall.name
    if ($payload.toolCall.args) {
        if ($payload.toolCall.args.CommandLine) {
            $details = "cmd: " + $payload.toolCall.args.CommandLine
        } elseif ($payload.toolCall.args.Path) {
            $details = "file: " + $payload.toolCall.args.Path
        }
    }
}

$errorStatus = if ($payload.error) { " [FAILED: $($payload.error)]" } else { " [SUCCESS]" }
$logEntry = "[$timestamp] TOOL=$toolName$errorStatus DETAILS=$details"

try {
    Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue
} catch {}

@{} | ConvertTo-Json -Compress
