# App Studio - session start
# Reports project state in a single line. Must stay cheap: reads only .state/project.json.
# NOTE: this file is intentionally ASCII-only (Windows PowerShell 5.1 compatibility).

$ErrorActionPreference = 'SilentlyContinue'

$statePath = ".state/project.json"

if (-not (Test-Path $statePath)) {
    Write-Output "App Studio ready. New project: /kickoff <your idea>  |  Existing code: /onboard"
    exit 0
}

try {
    $state = Get-Content -LiteralPath $statePath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Output "App Studio: could not read .state/project.json."
    exit 0
}

$parts = @()
if ($state.project)       { $parts += [string]$state.project }
if ($state.phase)         { $parts += "phase=" + $state.phase }
if ($state.currentSprint) { $parts += "sprint=" + $state.currentSprint }
if ($state.reviewMode)    { $parts += "mode=" + $state.reviewMode }

$line = "App Studio: " + ($parts -join " | ")

if ($state.counters) {
    $line += " | stories " + $state.counters.done + "/" + $state.counters.stories
}

if ($state.openGateConditions -and $state.openGateConditions -gt 0) {
    $line += " | OPEN GATES: " + $state.openGateConditions
}

Write-Output $line
Write-Output "Continue with: /status"
exit 0
