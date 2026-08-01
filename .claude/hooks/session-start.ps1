# App Studio - oturum baslangici
# Proje durumunu tek satirda bildirir. Ucuz olmali: sadece .state/project.json okunur.
# NOT: Bu dosya bilerek yalnizca ASCII karakter icerir (Windows PowerShell 5.1 uyumu).

$ErrorActionPreference = 'SilentlyContinue'

$statePath = ".state/project.json"

if (-not (Test-Path $statePath)) {
    Write-Output "App Studio hazir. Yeni proje icin: /kickoff <proje fikrin>  |  Mevcut kod icin: /onboard"
    exit 0
}

try {
    $state = Get-Content -LiteralPath $statePath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Output "App Studio: .state/project.json okunamadi."
    exit 0
}

$parts = @()
if ($state.project)       { $parts += [string]$state.project }
if ($state.phase)         { $parts += "faz=" + $state.phase }
if ($state.currentSprint) { $parts += "sprint=" + $state.currentSprint }
if ($state.reviewMode)    { $parts += "mod=" + $state.reviewMode }

$line = "App Studio: " + ($parts -join " | ")

if ($state.counters) {
    $line += " | story " + $state.counters.done + "/" + $state.counters.stories
}

if ($state.openGateConditions -and $state.openGateConditions -gt 0) {
    $line += " | ACIK KAPI: " + $state.openGateConditions
}

Write-Output $line
Write-Output "Devam icin: /status"
exit 0
