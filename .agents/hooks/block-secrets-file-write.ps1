# Block Secrets File Write / Edit Hook
# Hard-deny writing or modifying .env, keys, or credential files directly.

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

$fileName = [System.IO.Path]::GetFileName($filePath).ToLower()

# Allow .env.example, block actual .env or keys
if ($fileName -eq ".env.example") {
    @{ decision = "allow" } | ConvertTo-Json -Compress
    exit 0
}

$blockedPatterns = @(
    '^\.env(\..+)?$',
    '\.pem$',
    '\.key$',
    '\.pfx$',
    'credentials\.json$',
    'service-account.*\.json$'
)

$blocked = $false
foreach ($pattern in $blockedPatterns) {
    if ($fileName -match $pattern) {
        $blocked = $true
        break
    }
}

if ($blocked) {
    @{
        decision = "deny"
        reason   = "ZERO-TRUST VIOLATION (Rule 8 - Secrets Protection): Modifying or writing directly to actual environment or credentials files ('$fileName') is forbidden. Use .env.example with placeholders only."
    } | ConvertTo-Json -Compress
} else {
    @{ decision = "allow" } | ConvertTo-Json -Compress
}
