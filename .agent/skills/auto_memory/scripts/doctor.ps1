# Memory Doctor - Auditor de Integridad para Auto_Memory
# Mision: Verificar que los Indices, Detalle y Formatos de memoria esten sincronizados.
# Version compatible con PowerShell 5.1 y 7+

# Ajuste: Subimos niveles desde la carpeta de la skill (.agent/skills/auto_memory/scripts/) hasta la raiz
$MemoryPath = Join-Path $PSScriptRoot "..\..\..\..\Auto_memory"
$ReportErrors = 0
$ReportWarnings = 0
$TotalLinksAcrossIndices = 0

Clear-Host
Write-Host "--- BIENVENIDO AL MEMORY DOCTOR ---" -ForegroundColor Cyan
Write-Host "Escaneando: $MemoryPath`n" -ForegroundColor Gray

if (!(Test-Path $MemoryPath)) {
    Write-Host "[X] ERROR CRITICO: No se encuentra la carpeta 'Auto_memory'." -ForegroundColor Red
    exit
}

# 1. Auditoria de Indices y Enlaces
Write-Host "--- 1. Auditoria de Indices y Enlaces ---" -ForegroundColor Yellow
$Indices = Get-ChildItem -Path $MemoryPath -Filter "INDEX_*.md"
$ReferencedFiles = New-Object System.Collections.Generic.HashSet[string]

if ($Indices.Count -eq 0) {
    Write-Host "[!] ADVERTENCIA: No se encontraron archivos INDEX_*.md." -ForegroundColor Yellow
    $ReportWarnings++
}

foreach ($Index in $Indices) {
    Write-Host "Checking: $($Index.Name)... " -NoNewline
    $Content = Get-Content $Index.FullName -Raw
    
    # Buscamos AMBOS patrones:
    # 1. Links Markdown estandar: [texto](ruta/archivo.md)
    # 2. Links simples del tipo: [archivo.md]
    $RegexMarkdown = '\[[^\]]+\]\(([^)]+\.md)\)'  # Captura la RUTA en Markdown
    $RegexSimple   = '(?<!\))\[([^\]]+\.md)\](?!\()' # Captura [archivo.md] sin parentesis adyacentes
    
    $MatchesMarkdown = [System.Text.RegularExpressions.Regex]::Matches($Content, $RegexMarkdown)
    $MatchesSimple   = [System.Text.RegularExpressions.Regex]::Matches($Content, $RegexSimple)
    $RegexMatches    = @($MatchesMarkdown) + @($MatchesSimple)
    
    $CurrentIndexErrors = 0
    foreach ($Match in $RegexMatches) {
        # Grupo 1 captura la ruta en ambos regex
        $RawPath = $Match.Groups[1].Value.TrimStart('.','/')
        $FilePath = Join-Path $MemoryPath $RawPath
        $TotalLinksAcrossIndices++
        
        if (!(Test-Path $FilePath)) {
            if ($CurrentIndexErrors -eq 0) { Write-Host "[FALLO]" -ForegroundColor Red }
            Write-Host "    [X] Archivo no existe: $RawPath" -ForegroundColor Red
            $CurrentIndexErrors++
            $ReportErrors++
        } else {
            $null = $ReferencedFiles.Add($RawPath.ToLower())
        }
    }
    
    if ($CurrentIndexErrors -eq 0) { Write-Host "[OK]" -ForegroundColor Green }
}

# 2. Auditoria de Estructura de Detalles (Secciones Obligatorias)
Write-Host "`n--- 2. Auditoria de Detalles (Estructura) ---" -ForegroundColor Yellow
# Buscamos en histories/ y sessions/ donde realmente viven los archivos de memoria
$Details = Get-ChildItem -Path $MemoryPath -Filter "*.md" -Recurse | Where-Object { $_.Name -notlike "INDEX_*" -and $_.Name -notlike "MEMORY_PROTOCOL*" }

foreach ($Detail in $Details) {
    Write-Host "Checking: $($Detail.Name)... " -NoNewline
    $DetailContent = Get-Content $Detail.FullName -Raw
    $MissingSections = @()
    
    if ($DetailContent -notmatch "## What") { $MissingSections += "What" }
    if ($DetailContent -notmatch "## Why") { $MissingSections += "Why" }
    if ($DetailContent -notmatch "## Where") { $MissingSections += "Where" }
    if ($DetailContent -notmatch "## Learned") { $MissingSections += "Learned" }
    
    if ($MissingSections.Count -gt 0) {
        Write-Host "[ESTRUCTURA INCOMPLETA]" -ForegroundColor Red
        Write-Host "    [!] Faltan secciones: $($MissingSections -join ', ')" -ForegroundColor Red
        $ReportErrors++
    } else {
        Write-Host "[OK]" -ForegroundColor Green
    }
}

# 3. Deteccion de Archivos Huerfanos
Write-Host "`n--- 3. Deteccion de Archivos Huerfanos ---" -ForegroundColor Yellow
$OrphanCount = 0
foreach ($Detail in $Details) {
    if (!$ReferencedFiles.Contains($Detail.Name.ToLower())) {
        Write-Host "    [-] Archivo Huerfano (No esta en ningun indice): $($Detail.Name)" -ForegroundColor Yellow
        $OrphanCount++
        $ReportWarnings++
    }
}

if ($OrphanCount -eq 0) { Write-Host "    [OK] No se detectaron archivos huerfanos." -ForegroundColor Green }

# 4. Reporte Final
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "REPORTE FINAL DE SALUD DE MEMORIA" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "- Enlaces totales en indices: $TotalLinksAcrossIndices"

$ErrorColor = "Gray"; if ($ReportErrors -gt 0) { $ErrorColor = "Red" }
$WarnColor = "Gray"; if ($ReportWarnings -gt 0) { $WarnColor = "Yellow" }

Write-Host "- Errores de Integridad (X): $ReportErrors" -ForegroundColor $ErrorColor
Write-Host "- Advertencias/Huerfanos (!): $ReportWarnings" -ForegroundColor $WarnColor

if ($ReportErrors -eq 0 -and $ReportWarnings -eq 0) {
    Write-Host "`n[CONGRATULATIONS] ¡Tu memoria estrategica tiene una salud de hierro! 🚀" -ForegroundColor Green
} elseif ($ReportErrors -eq 0) {
    Write-Host "`n[ALERTA] El sistema es solido, pero podrias limpiar archivos huerfanos." -ForegroundColor Yellow
} else {
    Write-Host "`n[CRITICAL] Atencion: Hay enlaces rotos o archivos incompletos. ¡Corrigelo!" -ForegroundColor Red
}

Write-Host "`nPresiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
