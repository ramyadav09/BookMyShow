# Block All Commands - Force Ask Hook
# Even if auto-mode/YOLO mode is enabled, every shell command execution prompts the user with force_ask.

$inputContent = [Console]::In.ReadToEnd()
if (-not $inputContent) {
    @{ decision = "force_ask"; reason = "Zero-trust gate: Shell command execution requires explicit user approval." } | ConvertTo-Json -Compress
    exit 0
}

try {
    $payload = $inputContent | ConvertFrom-Json
} catch {
    @{ decision = "force_ask"; reason = "Zero-trust gate: Shell command execution requires explicit user approval." } | ConvertTo-Json -Compress
    exit 0
}

$commandLine = "unknown command"
if ($payload.toolCall -and $payload.toolCall.args -and $payload.toolCall.args.CommandLine) {
    $commandLine = [string]$payload.toolCall.args.CommandLine
}

@{
    decision = "force_ask"
    reason   = "ZERO-TRUST GATE: Command execution requested: '$commandLine'. Explicit consent ('OK' / 'Go') is required. Auto-mode / YOLO bypass is disabled."
} | ConvertTo-Json -Compress
