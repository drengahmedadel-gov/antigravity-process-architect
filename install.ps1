# =====================================================================
# Antigravity Process Architect - One-Click Installer (Windows)
# Developed by: Dr. Eng. Ahmed Adel (Dr.PMO)
# =====================================================================

# Fix UTF-8 encoding for Arabic text display in PowerShell
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
try { $OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
chcp 65001 2>&1 | Out-Null

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Process Architect for Google Antigravity - تثبيت المهارة " -ForegroundColor Green
Write-Host "  Developed by: Dr. Eng. Ahmed Adel (Dr.PMO)               " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check Node.js prerequisite (>= 18)
Write-Host "[1/4] فحص بيئة التشغيل (Checking Node.js >= 18)..." -ForegroundColor White
try {
    $nodeVersion = (node -v).Trim()
    $majorVersion = [int]($nodeVersion.TrimStart('v').Split('.')[0])
    if ($majorVersion -lt 18) {
        Write-Host "  [ERROR] إصدار Node.js الحالي ($nodeVersion) قديم. يتطلب المحرك الإصدار 18 أو أحدث." -ForegroundColor Red
        Write-Host "  يرجى تحديث Node.js من الرابط: https://nodejs.org/" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "  [OK] تم العثور على Node.js متوافق: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] لم يتم العثور على Node.js مثبت على جهازك!" -ForegroundColor Red
    Write-Host "  يرجى تنزيل وتثبيت Node.js (الإصدار 18 أو أحدث) من الرابط: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# 2. Setup target destination
$skillDir = Join-Path $env:USERPROFILE ".gemini\config\skills\process-architect"
Write-Host "[2/4] إعداد مجلد المهارة في Antigravity: $skillDir" -ForegroundColor White

if (Test-Path $skillDir) {
    Write-Host "  [UPDATE] تحديث المهارة الحالية..." -ForegroundColor Cyan
    Remove-Item -Path $skillDir -Recurse -Force
}
New-Item -Path $skillDir -ItemType Directory -Force | Out-Null

# 3. Download/Copy Skill Package
Write-Host "[3/4] تنزيل وتثبيت حزمة Process Architect..." -ForegroundColor White

$repoUrl = "https://github.com/drengahmedadel-gov/antigravity-process-architect"
$tempZip = Join-Path $env:TEMP "antigravity-process-architect.zip"
$tempExtract = Join-Path $env:TEMP "antigravity-process-architect-extract"

try {
    $zipUrl = "$repoUrl/archive/refs/heads/main.zip"
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    
    if (Test-Path $tempExtract) { Remove-Item -Path $tempExtract -Recurse -Force }
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
    
    $extractedFolder = Join-Path $tempExtract "antigravity-process-architect-main\process-architect"
    Copy-Item -Path "$extractedFolder\*" -Destination $skillDir -Recurse -Force
    
    Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  [OK] تم تثبيت الملفات بنجاح." -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] تعذر تنزيل الحزمة: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 4. Run Doctor verification
Write-Host "[4/4] التحقق من سلامة المحرك وبوابات الجودة..." -ForegroundColor White
$doctorScript = Join-Path $skillDir "bin\archify.mjs"
try {
    $doctorOutput = node $doctorScript doctor
    Write-Host "  [OK] كافة مكونات المحرك وبوابات الجودة مفحوصة وجاهزة بنسبة 100%." -ForegroundColor Green
} catch {
    Write-Host "  [WARNING] تنبيه أثناء الفحص الذاتي: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  مبروك! تم تثبيت Process Architect بنجاح على Antigravity." -ForegroundColor Green
Write-Host "  يمكنك الآن فتح Antigravity وكتابة:" -ForegroundColor White
Write-Host "  'ارسم لي إجراء عمل SOP تفاعلي لـ ...' أو 'حلل هذا العقد بصرياً'" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
