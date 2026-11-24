# Block Secrets Access via CLI Hook
# Hard-deny any command trying to cat, type, echo, or inspect .env, keys, or credentials.

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

# Match attempts to inspect env files or secret keys
$secretPatterns = @(
    '\.env(\.|$|\s)',
    'id_rsa',
    'id_ed25519',
    '\.pem\b',
    '\.key\b',
    '\.pfx\b',
    'credentials\.json',
    'service-account',
    'token\.json'
)

$blocked = $false
$matched = ""
foreach ($pattern in $secretPatterns) {
    # If command contains secret file references and reading/printing utilities
    if ($commandLower -match $pattern) {
        # Check if it's inspecting or printing
        if ($commandLower -match '(cat|type|get-content|gc|head|tail|grep|select-string|more|less|echo|print)') {
            $blocked = $true
            $matched = $pattern
            break
        }
    }
}

if ($blocked) {
    @{
        decision = "deny"
        reason   = "ZERO-TRUST VIOLATION (Rule 8 - Secrets Protection): CLI access/inspection of environment or secret credential files is strictly forbidden (pattern: '$matched')."
    } | ConvertTo-Json -Compress
} else {
    @{ decision = "allow" } | ConvertTo-Json -Compress
}
