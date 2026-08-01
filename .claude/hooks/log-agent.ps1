# App Studio - subagent run log
# Accumulates the agent invocation count for token analysis. /status and /retro read this.
# NOTE: this file is intentionally ASCII-only (Windows PowerShell 5.1 compatibility).

$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }

$logDir  = ".state"
$logPath = "$logDir/agent-log.jsonl"

if (-not (Test-Path $logDir)) { exit 0 }

$sprint = $null
if (Test-Path "$logDir/project.json") {
    try {
        $state  = Get-Content "$logDir/project.json" -Raw -Encoding UTF8 | ConvertFrom-Json
        $sprint = $state.currentSprint
    } catch { }
}

$entry = [ordered]@{
    ts     = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
    sprint = $sprint
}

try {
    $payload = $raw | ConvertFrom-Json
    if ($payload.agent_type)    { $entry.agent = $payload.agent_type }
    if ($payload.subagent_type) { $entry.agent = $payload.subagent_type }
} catch { }

($entry | ConvertTo-Json -Compress) | Add-Content -Path $logPath -Encoding utf8

exit 0
