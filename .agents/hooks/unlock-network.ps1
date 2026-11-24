<#
.SYNOPSIS
    Unlocks network access for a temporary, timed window.
.PARAMETER Minutes
    Duration in minutes to keep network unlocked (default: 5, max: 30).
.PARAMETER Reason
    Reason for network access (e.g. "pnpm install dependencies").
#>

param(
    [int]$Minutes = 5,
    [string]$Reason = "User approved maintenance"
)

if ($Minutes -lt 1) { $Minutes = 1 }
if ($Minutes -gt 30) { $Minutes = 30 }

$nowUtc = [DateTime]::UtcNow
$expiresAtUtc = $nowUtc.AddMinutes($Minutes)

$leaseData = @{
    createdAtUtc = $nowUtc.ToString("o")
    expiresAtUtc = $expiresAtUtc.ToString("o")
    minutes      = $Minutes
    reason       = $Reason
}

$leaseFilePath = Join-Path $PSScriptRoot "..\.network_lease"
$leaseData | ConvertTo-Json | Set-Content -Path $leaseFilePath -Force

Write-Host "==========================================================" -ForegroundColor Green
Write-Host " NETWORK TEMPORARILY UNLOCKED" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Duration    : $Minutes minutes"
Write-Host "Expires At  : $($expiresAtUtc.ToLocalTime().ToString('yyyy-MM-dd HH:mm:ss')) (Local)"
Write-Host "Reason      : $Reason"
Write-Host "Lease File  : $leaseFilePath"
Write-Host "==========================================================" -ForegroundColor Green
