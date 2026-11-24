# Block Publish Commands Hook
# Reads tool call JSON from stdin and blocks npm/pnpm/yarn publish and deploy commands.

$input = [Console]::In.ReadToEnd()
$payload = $input | ConvertFrom-Json

$commandLine = ""
if ($payload.toolCall -and $payload.toolCall.args) {
    $commandLine = $payload.toolCall.args.CommandLine
    if (-not $commandLine) { $commandLine = "" }
}

$commandLower = $commandLine.ToLower().Trim()

# Patterns for publish/deploy operations
$publishPatterns = @(
    'npm\s+publish',
    'pnpm\s+publish',
    'yarn\s+publish',
    'npx\s+.*publish',
    'vercel\s+deploy',
    'vercel\s+--prod',
    'railway\s+up',
    'netlify\s+deploy',
    'docker\s+push',
    'docker\s+system\s+prune',
    'gh\s+release',
    'wrangler\s+publish',
    'wrangler\s+deploy',
    'fly\s+deploy'
)

$blocked = $false
foreach ($pattern in $publishPatterns) {
    if ($commandLower -match $pattern) {
        $blocked = $true
        break
    }
}

if ($blocked) {
    $result = @{
        decision = "deny"
        reason = "GUARDRAIL VIOLATION: Publishing and deployment commands are forbidden. Agents must never push packages to registries or deploy to production. The user handles all publishing and deployments."
    }
} else {
    $result = @{
        decision = "allow"
    }
}

$result | ConvertTo-Json -Compress
