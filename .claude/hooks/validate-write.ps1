# App Studio - post-write validation
# Emits warnings, DOES NOT BLOCK the operation (exit 0).
# Purpose: make silent rule violations visible.
# NOTE: this file is intentionally ASCII-only (Windows PowerShell 5.1 compatibility).

$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }

try { $payload = $raw | ConvertFrom-Json } catch { exit 0 }

$filePath = $payload.tool_input.file_path
if (-not $filePath) { exit 0 }
if (-not (Test-Path $filePath)) { exit 0 }

$warnings = @()
$name = Split-Path $filePath -Leaf
$norm = $filePath -replace '\\', '/'

function Get-Text($p) {
    return (Get-Content -LiteralPath $p -Raw -Encoding UTF8 -ErrorAction SilentlyContinue)
}

# 1. Secret files
if ($name -match '^\.env' -or $norm -match '/secrets/' -or $name -match '\.(pem|key|p12|pfx)$') {
    $warnings += "SECRET FILE: $name - must not be versioned, contents must not be printed."
}

# 2. Hardcoded secrets / weak randomness in source
if ($norm -match '/(src|infra|db)/') {
    $c = Get-Text $filePath
    if ($c -match '(?i)(api[_-]?key|secret|password|token)\s*[:=]\s*["''][^"'']{12,}["'']') {
        $warnings += "POSSIBLE HARDCODED SECRET: $norm - secrets belong in a secret manager, not in code."
    }
    if ($c -match 'Math\.random\(\)' -and $norm -match '(auth|token|session|crypto|password)') {
        $warnings += "WEAK RANDOMNESS: $norm - Math.random must not be used in a security context."
    }
}

# 3. Migration reversibility
if ($norm -match '/migrations/.*\.sql$') {
    $c = Get-Text $filePath
    if ($c -notmatch '(?i)--\s*\+?down') {
        $warnings += "IRREVERSIBLE MIGRATION: $norm - the down section is missing."
    }
    if ($c -match '(?i)\b(DROP\s+TABLE|DROP\s+DATABASE|TRUNCATE)\b') {
        $warnings += "DESTRUCTIVE SQL: $norm - DROP/TRUNCATE detected."
    }
}

# 4. skip/only left in a test file
if ($name -match '\.(test|spec)\.') {
    $c = Get-Text $filePath
    if ($c -match '\b(it|test|describe)\.(only|skip)\b|\bxit\b|\bfdescribe\b') {
        $warnings += "TEST MARKER: $norm - skip/only must not be committed."
    }
}

# 5. CONTEXT.md size limit
if ($norm -match 'docs/CONTEXT\.md$') {
    $n = (Get-Content -LiteralPath $filePath -Encoding UTF8 | Measure-Object -Line).Lines
    if ($n -gt 200) {
        $warnings += "CONTEXT.md IS BLOATED: $n lines (limit 200). Run /context-compact."
    }
}

# 6. Story task-packet completeness
if ($norm -match '/epics/.*/story-\d+.*\.md$') {
    $c = Get-Text $filePath
    $missing = @()
    if ($c -notmatch '(?m)^##\s*Acceptance criteria') { $missing += 'Acceptance criteria' }
    if ($c -notmatch '(?m)^##\s*Out of scope')        { $missing += 'Out of scope' }
    if ($c -notmatch '(?m)^##\s*Required evidence')   { $missing += 'Required evidence' }
    if ($c -notmatch '(?m)^##\s*Test scenarios')      { $missing += 'Test scenarios' }
    if ($missing.Count -gt 0) {
        $warnings += ("STORY MISSING SECTIONS: {0} - {1}. An incomplete task packet raises /dev-task cost." -f $name, ($missing -join ', '))
    }
}

if ($warnings.Count -gt 0) {
    Write-Output "App Studio check:"
    foreach ($w in $warnings) { Write-Output ("  ! " + $w) }
}

exit 0
