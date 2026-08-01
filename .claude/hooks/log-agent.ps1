# App Studio - alt-agent calisma kaydi
# Token analizi icin agent cagri sayisini biriktirir. /status ve /retro bunu okur.
# NOT: Bu dosya bilerek yalnizca ASCII karakter icerir (Windows PowerShell 5.1 uyumu).

$ErrorActionPreference = 'SilentlyContinue'

$input_json = [Console]::In.ReadToEnd()
if (-not $input_json) { exit 0 }

$logDir  = ".state"
$logPath = "$logDir/agent-log.jsonl"

if (-not (Test-Path $logDir)) { exit 0 }

$sprint = $null
if (Test-Path "$logDir/project.json") {
    try {
        $state  = Get-Content "$logDir/project.json" -Raw | ConvertFrom-Json
        $sprint = $state.currentSprint
    } catch { }
}

$entry = [ordered]@{
    ts     = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
    sprint = $sprint
}

try {
    $payload = $input_json | ConvertFrom-Json
    if ($payload.agent_type)  { $entry.agent = $payload.agent_type }
    if ($payload.subagent_type) { $entry.agent = $payload.subagent_type }
} catch { }

($entry | ConvertTo-Json -Compress) | Add-Content -Path $logPath -Encoding utf8

exit 0
