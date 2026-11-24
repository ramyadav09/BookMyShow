# Block Git & GitHub CLI Commands Hook
# Allows safe READ-ONLY git commands (status, diff, log, show).
# Strictly hard-denies all mutations (commit, push, add, reset, pull, checkout, etc.) and all gh CLI commands.

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

# 1. Hard-deny ALL GitHub CLI (gh) commands
if ($commandLower -match '(^|[\s;&|])gh(\.exe)?([\s;&|]|$)') {
    @{
        decision = "deny"
        reason   = "ZERO-TRUST VIOLATION: All GitHub CLI ('gh') commands are strictly forbidden. The user manages GitHub PRs/issues/releases manually."
    } | ConvertTo-Json -Compress
    exit 0
}

# 2. Check if a git command is present
if ($commandLower -match '(^|[\s;&|])git(\.exe)?([\s;&|]|$)') {
    # Strictly forbidden Git mutating subcommands and flags
    $forbiddenGitOperations = @(
        'add', 'commit', 'push', 'pull', 'merge', 'rebase',
        'reset', 'checkout', 'switch', 'restore', 'clean',
        'stash', 'branch\s+-[dDmM]', 'tag', 'remote\s+add',
        'remote\s+set', 'remote\s+remove', 'cherry-pick',
        'revert', 'init', 'clone', 'submodule'
    )

    foreach ($forbidden in $forbiddenGitOperations) {
        if ($commandLower -match "(^|[\s;&|])git(\.exe)?\s+$forbidden\b") {
            @{
                decision = "deny"
                reason   = "ZERO-TRUST VIOLATION (Git Mutation Locked): 'git $forbidden' is forbidden. Only READ-ONLY git commands (git status, git diff, git log, git show, git branch list) are allowed. State-modifying operations must be run by the user manually."
            } | ConvertTo-Json -Compress
            exit 0
        }
    }

    # Allowed read-only subcommands
    $allowedReadOnly = @(
        '(^|[\s;&|])git(\.exe)?\s+status\b',
        '(^|[\s;&|])git(\.exe)?\s+diff\b',
        '(^|[\s;&|])git(\.exe)?\s+log\b',
        '(^|[\s;&|])git(\.exe)?\s+show\b',
        '(^|[\s;&|])git(\.exe)?\s+branch(\s*$|\s+--list|\s+-a|\s+-r)',
        '(^|[\s;&|])git(\.exe)?\s+remote\s+(-v|--verbose|\s*$)',
        '(^|[\s;&|])git(\.exe)?\s+rev-parse\b',
        '(^|[\s;&|])git(\.exe)?\s+describe\b',
        '(^|[\s;&|])git(\.exe)?\s+--version\b'
    )

    $isReadOnly = $false
    foreach ($pattern in $allowedReadOnly) {
        if ($commandLower -match $pattern) {
            $isReadOnly = $true
            break
        }
    }

    if (-not $isReadOnly) {
        @{
            decision = "deny"
            reason   = "ZERO-TRUST VIOLATION: Unrecognized or non-whitelisted git operation in '$commandLine'. Allowed read-only commands: 'git status', 'git diff', 'git log', 'git show', 'git branch', 'git remote -v'."
        } | ConvertTo-Json -Compress
        exit 0
    }
}

@{ decision = "allow" } | ConvertTo-Json -Compress
