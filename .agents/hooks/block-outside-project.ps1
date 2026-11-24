# Block Write/Edit Outside Project Directory Hook
# Dynamically resolves project root from script location (works anywhere).

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

$filePath = ""
if ($payload.toolCall -and $payload.toolCall.args -and $payload.toolCall.args.Path) {
    $filePath = [string]$payload.toolCall.args.Path
}

# Dynamically resolve root: .agents/hooks/../.. -> Workspace Root
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path.ToLower().TrimEnd('\', '/')
$normPath = $filePath.ToLower().Replace("/", "\").TrimEnd('\', '/')

# Allow agent platform brain artifacts
$brainPath = "c:\users\kiit\.gemini\antigravity\brain"

if ($normPath.StartsWith($brainPath)) {
    @{ decision = "allow" } | ConvertTo-Json -Compress
    exit 0
}

if (-not $normPath.StartsWith($projectRoot)) {
    @{
        decision = "deny"
        reason   = "ZERO-TRUST VIOLATION (Workspace Isolation): Writing or editing outside the workspace root is forbidden. File: '$filePath'. Workspace root: '$projectRoot'."
    } | ConvertTo-Json -Compress
} else {
    @{ decision = "allow" } | ConvertTo-Json -Compress
}
