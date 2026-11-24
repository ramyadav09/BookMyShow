# Scan Secrets Hook (PreToolUse on write_file & edit_file)
# Blocks any file write that contains hardcoded credentials, API keys, or private keys.

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

$contentToCheck = ""
$filePath = ""

if ($payload.toolCall -and $payload.toolCall.args) {
    if ($payload.toolCall.args.Content) {
        $contentToCheck += [string]$payload.toolCall.args.Content
    }
    if ($payload.toolCall.args.Replacement) {
        $contentToCheck += [string]$payload.toolCall.args.Replacement
    }
    if ($payload.toolCall.args.Path) {
        $filePath = [string]$payload.toolCall.args.Path
    }
}

# If it's a documentation file or template (.md, .json example), skip strict leak checks
$fileName = [System.IO.Path]::GetFileName($filePath).ToLower()
if ($fileName.EndsWith(".md") -or $fileName -eq ".env.example") {
    @{ decision = "allow" } | ConvertTo-Json -Compress
    exit 0
}

# Signatures for actual secret leaks
$secretPatterns = @(
    'AKIA[0-9A-Z]{16}',                                     # AWS Access Key
    '(?i)aws_secret_access_key\s*=\s*[''"][A-Za-z0-9/+=]{40}[''"]', # AWS Secret
    'ghp_[0-9a-zA-Z]{36}',                                   # GitHub Personal Access Token
    'github_pat_[0-9a-zA-Z_]{82}',                          # GitHub Fine-grained PAT
    'sk_live_[0-9a-zA-Z]{24}',                              # Stripe Live Secret Key
    'rk_live_[0-9a-zA-Z]{24}',                              # Stripe Live Restricted Key
    'AIza[0-9A-Za-z\\-_]{35}',                              # Google API Key
    '-----BEGIN (RSA|EC|DSA|OPENSSH|PRIVATE) KEY-----'     # Private Keys
)

$detectedSecret = ""
foreach ($pattern in $secretPatterns) {
    if ($contentToCheck -match $pattern) {
        $detectedSecret = $matches[0]
        break
    }
}

if ($detectedSecret) {
    @{
        decision = "deny"
        reason   = "ZERO-TRUST VIOLATION: Hardcoded credential or live secret detected in code ('$detectedSecret'). Never embed live secrets in source files. Reference environment variables via process.env or configuration loaders instead."
    } | ConvertTo-Json -Compress
} else {
    @{ decision = "allow" } | ConvertTo-Json -Compress
}
