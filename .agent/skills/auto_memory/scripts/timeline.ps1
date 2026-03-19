# Auto_Memory Timeline Visualizer - Cronoscopio
# Mision: Reconstruir la historia del proyecto desde sus origenes hasta el hito mas reciente.

param(
    [Parameter(Mandatory=$false)]
    [int]$Last = 10,   # Ultimos X eventos
    
    [Parameter(Mandatory=$false)]
    [string]$DateFilter  # Solo mostrar eventos de este dia (YYYY-MM-DD)
)

$MemoryPath = Join-Path $PSScriptRoot "..\..\..\..\Auto_memory"
$HistoriesPath = Join-Path $MemoryPath "histories"
$SessionsPath = Join-Path $MemoryPath "sessions"

if (!(Test-Path $MemoryPath)) {
    Write-Host "[X] ERROR: No se encuentra la raiz de la memoria." -ForegroundColor Red
    exit
}

Write-Host "--- AUTO_MEMORY TIMELINE UNIFICADO ---" -ForegroundColor Cyan

$TimelineEntries = @()

# Escaneamos histories y sessions
$Files = Get-ChildItem -Path $HistoriesPath, $SessionsPath -Filter "*.md" -Recurse

foreach ($File in $Files) {
    # Buscamos encabezados fechados del tipo ### [YYYY-MM-DD]
    $ContentLines = Get-Content $File.FullName
    
    # Ademas de los encabezados, buscamos en los resúmenes de sesion (Session Summary)
    foreach ($Line in $ContentLines) {
        if ($Line -match "### \[(\d{4}-\d{2}-\d{2})\]") {
            $EventDate = $Matches[1]
            $Snippet = $Line -replace "### \[\d{4}-\d{2}-\d{2}\]", ""
            
            $TimelineEntries += [PSCustomObject]@{
                Date = $EventDate
                Topic = $File.BaseName
                Detail = $Snippet.Trim(": ")
                Type = if ($File.FullName -match "sessions") { "SESSION" } else { "HISTORY" }
            }
        }
    }
    
    # Para archivos que NO tienen encabezados fechados pero tienen la fecha en el nombre (retrocompatibilidad)
    if ($File.BaseName -match "^(\d{4}-\d{2}-\d{2})_") {
        $EventDate = $Matches[1]
        $TimelineEntries += [PSCustomObject]@{
            Date = $EventDate
            Topic = $File.BaseName -replace "^\d{4}-\d{2}-\d{2}_", ""
            Detail = "Hito/Sesión (Legacy)"
            Type = if ($File.FullName -match "sessions") { "SESSION" } else { "HISTORY" }
        }
    }
}

if ($TimelineEntries.Count -eq 0) {
    Write-Host "[!] No se encontraron eventos fechados en el cerebro." -ForegroundColor Yellow
    exit
}

# Aplicamos filtros
$FilteredEntries = $TimelineEntries | Sort-Object Date -Descending

if ($DateFilter) {
    $FilteredEntries = $FilteredEntries | Where-Object { $_.Date -eq $DateFilter }
    Write-Host "Filtrando por fecha: $DateFilter`n" -ForegroundColor Gray
}

# Tomamos los ultimos X
$DisplayEntries = $FilteredEntries | Select-Object -First $Last

# Mostrar resultado
foreach ($Entry in $DisplayEntries) {
    $Color = if ($Entry.Type -eq "SESSION") { "Green" } else { "Magenta" }
    Write-Host "[$($Entry.Date)] " -ForegroundColor DarkGray -NoNewline
    Write-Host "[$($Entry.Type)] " -ForegroundColor $Color -NoNewline
    Write-Host "[$($Entry.Topic)] " -ForegroundColor Cyan -NoNewline
    Write-Host "$($Entry.Detail)"
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Mostrando $($DisplayEntries.Count) de $($FilteredEntries.Count) eventos totales." -ForegroundColor Gray
Write-Host "==========================================" -ForegroundColor Cyan
