# Auto_Memory Stats Dashboard - Panel de Control
# Mision: Cuantificar el crecimiento del cerebro del proyecto y el progreso estrategico.

$MemoryPath = Join-Path $PSScriptRoot "..\..\..\..\Auto_memory"
$HistoriesPath = Join-Path $MemoryPath "histories"
$SessionsPath = Join-Path $MemoryPath "sessions"
$MilestonesFile = Join-Path $MemoryPath "INDEX_milestones.md"

if (!(Test-Path $MemoryPath)) {
    Write-Host "[X] ERROR: No se encuentra la raiz de la memoria." -ForegroundColor Red
    exit
}

Write-Host "--- AUTO_MEMORY STATS DASHBOARD ---" -ForegroundColor Cyan

# 1. Conteo de Conocimiento (Histories)
$HistoriesDocs = Get-ChildItem -Path $HistoriesPath -Filter "*.md"
$TotalObservations = $HistoriesDocs.Count

# 2. Conteo de Experiencia (Sessions)
$SessionsDocs = Get-ChildItem -Path $SessionsPath -Filter "*.md"
$TotalSessions = $SessionsDocs.Count

# 3. Analisis Estrategico (Milestones)
$MilestonesContent = Get-Content $MilestonesFile
$CompletedMilestones = 0
$TotalMilestones = 0

foreach ($Line in $MilestonesContent) {
    # Filtramos solo las filas de la tabla que tienen contenido (saltando el header y el separador)
    if ($Line -match "^\| " -and $Line -notmatch "---") {
        # Si tiene el primer pipe, es un hito
        $TotalMilestones++
        # Si tiene un check de exito (ajustamos para que sea laxo)
        if ($Line -match "✅" -or $Line -match "Done") { $CompletedMilestones++ }
    }
}
$ProgressPercent = if ($TotalMilestones -gt 0) { [Math]::Round(($CompletedMilestones / $TotalMilestones) * 100, 1) } else { 0 }

# 4. Salud del Sistema (para analisis completo, ejecutar doctor.ps1)

# --- PRESENTACION VISUAL ---
Write-Host "`n[CONOCIMIENTO ACUMULADO]" -ForegroundColor Yellow
Write-Host "  Historias Tecnicas (Topics) : $TotalObservations"
Write-Host "  Sesiones de Relevo (Sessions): $TotalSessions"

Write-Host "`n[PROGRESO ESTRATEGICO]" -ForegroundColor Yellow
Write-Host "  Hitos Completados : $CompletedMilestones de $TotalMilestones"
Write-Host "  Tasa de Exito     : $ProgressPercent%"

# Barra de progreso visual
$Bars = [Math]::Round($ProgressPercent / 5)
$EmptyBars = 20 - $Bars
Write-Host "  Progreso: [" -NoNewline
Write-Host ("#" * $Bars) -ForegroundColor Green -NoNewline
Write-Host ("-" * $EmptyBars) -ForegroundColor Gray -NoNewline
Write-Host "] ($ProgressPercent%)"

Write-Host "`n[TAXONOMIA]" -ForegroundColor Yellow
# Extraemos temas mas comunes
$TopTopics = $HistoriesDocs | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | Select-Object -ExpandProperty BaseName
Write-Host "  Temas Recientes: " -NoNewline
$TopTopics -join ", " | Write-Host -ForegroundColor Cyan

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "AUDITORIA DE MEMORIA COMPLETADA." -ForegroundColor Gray
Write-Host "==========================================" -ForegroundColor Cyan
