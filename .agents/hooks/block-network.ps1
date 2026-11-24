# Block Outbound Network & External Communication Hook (with Timed Lease Support)
# Allows temporary outbound access if an active lease file exists in .agents/.network_lease

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

$networkPatterns = @(
    '(^|[\s;&|])curl(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])wget(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])invoke-webrequest([\s;&|]|$)',
    '(^|[\s;&|])iwr([\s;&|]|$)',
    '(^|[\s;&|])invoke-restmethod([\s;&|]|$)',
    '(^|[\s;&|])irm([\s;&|]|$)',
    '(^|[\s;&|])ssh(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])scp(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])sftp(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])rsync(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])telnet(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])nc(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])ncat(\.exe)?([\s;&|]|$)',
    '(^|[\s;&|])netcat([\s;&|]|$)',
    'ngrok',
    'cloudflared',
    'localtunnel',
    'pagekite'
)

$matchedPattern = ""
foreach ($pattern in $networkPatterns) {
    if ($commandLower -match $pattern) {
        $matchedPattern = $pattern
        break
    }
}

# If no network command pattern detected, allow
if (-not $matchedPattern) {
    @{ decision = "allow" } | ConvertTo-Json -Compress
    exit 0
}

# --- TIMED LEASE CHECK ---
# Check for active lease file at E:\BookMyShow\.agents\.network_lease
$leaseFilePath = Join-Path $PSScriptRoot "..\.network_lease"

if (Test-Path $leaseFilePath) {
    try {
        $leaseData = Get-Content $leaseFilePath -Raw | ConvertFrom-Json
        $expiryTime = [DateTime]::Parse($leaseData.expiresAtUtc)
        $nowUtc = [DateTime]::UtcNow

        if ($nowUtc -lt $expiryTime) {
            $remainingMins = [math]::Round(($expiryTime - $nowUtc).TotalMinutes, 1)
            # Active lease in place: allow with logging
            @{
                decision = "allow"
            } | ConvertTo-Json -Compress
            exit 0
        } else {
            # Lease expired - remove stale lease file
            Remove-Item -Path $leaseFilePath -Force -ErrorAction SilentlyContinue
        }
    } catch {
        # Malformed lease - treat as locked
    }
}

# Network is locked without a valid lease
@{
    decision = "deny"
    reason   = "ZERO-TRUST VIOLATION (Network Locked): Outbound network tool detected ('$matchedPattern'). Network is currently locked. To grant temporary access, request user permission to unlock network for a timed duration (e.g., 5 or 10 minutes) using unlock-network.ps1."
} | ConvertTo-Json -Compress
