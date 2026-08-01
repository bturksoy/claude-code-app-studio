# App Studio - yazma sonrasi denetim
# Uyari uretir, ISLEMI ENGELLEMEZ (exit 0). Amac: sessiz kural ihlallerini gorunur kilmak.
# NOT: Bu dosya bilerek yalnizca ASCII karakter icerir (Windows PowerShell 5.1 uyumu).

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

# 1. Secret dosyalari
if ($name -match '^\.env' -or $norm -match '/secrets/' -or $name -match '\.(pem|key|p12|pfx)$') {
    $warnings += "SECRET DOSYASI: $name - versiyonlanmamali, icerigi ekrana basilmamali."
}

# 2. Kaynak kodda olasi sabit secret / zayif rastgelelik
if ($norm -match '/(src|infra|db)/') {
    $c = Get-Text $filePath
    if ($c -match '(?i)(api[_-]?key|secret|password|token)\s*[:=]\s*["''][^"'']{12,}["'']') {
        $warnings += "OLASI SABIT SECRET: $norm - secretlar kodda degil, secret yoneticisinde tutulur."
    }
    if ($c -match 'Math\.random\(\)' -and $norm -match '(auth|token|session|crypto|password)') {
        $warnings += "ZAYIF RASTGELELIK: $norm - guvenlik baglaminda Math.random kullanilmaz."
    }
}

# 3. Migration geri alinabilirligi
if ($norm -match '/migrations/.*\.sql$') {
    $c = Get-Text $filePath
    if ($c -notmatch '(?i)--\s*\+?down') {
        $warnings += "MIGRATION GERI ALINAMAZ: $norm - down bolumu eksik."
    }
    if ($c -match '(?i)\b(DROP\s+TABLE|DROP\s+DATABASE|TRUNCATE)\b') {
        $warnings += "YIKICI SQL: $norm - DROP/TRUNCATE tespit edildi."
    }
}

# 4. Test dosyasinda skip/only
if ($name -match '\.(test|spec)\.') {
    $c = Get-Text $filePath
    if ($c -match '\b(it|test|describe)\.(only|skip)\b|\bxit\b|\bfdescribe\b') {
        $warnings += "TEST ISARETI: $norm - skip/only commit edilmemeli."
    }
}

# 5. CONTEXT.md boyut limiti
if ($norm -match 'docs/CONTEXT\.md$') {
    $n = (Get-Content -LiteralPath $filePath -Encoding UTF8 | Measure-Object -Line).Lines
    if ($n -gt 200) {
        $warnings += "CONTEXT.md SISTI: $n satir (limit 200). /context-compact calistirin."
    }
}

# 6. Story gorev paketi butunlugu
#    Turkce baslik karakterlerinden kacinmak icin kisaltilmis desenler kullanilir.
if ($norm -match '/epics/.*/story-\d+.*\.md$') {
    $c = Get-Text $filePath
    $missing = @()
    if ($c -notmatch '(?m)^##\s*Kabul kriter')  { $missing += 'Kabul kriterleri' }
    if ($c -notmatch '(?m)^##\s*Kapsam D')      { $missing += 'Kapsam DISI' }
    if ($c -notmatch '(?m)^##\s*Zorunlu kan')   { $missing += 'Zorunlu kanit' }
    if ($c -notmatch '(?m)^##\s*Test senaryo')  { $missing += 'Test senaryolari' }
    if ($missing.Count -gt 0) {
        $warnings += ("STORY EKSIK BOLUM: {0} - {1}. Eksik gorev paketi /dev-task maliyetini artirir." -f $name, ($missing -join ', '))
    }
}

if ($warnings.Count -gt 0) {
    Write-Output "App Studio denetimi:"
    foreach ($w in $warnings) { Write-Output ("  ! " + $w) }
}

exit 0
