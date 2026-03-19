# Auto_Memory Harvester - Recolector de Aprendizajes Pasivos
# Mision: Extraer secciones de "Key Learnings" de cualquier archivo o texto.

param(
    [Parameter(Mandatory=$true, HelpMessage="Ruta al archivo fuente que contiene bloques '## Key Learnings:'")]
    [string]$SourceFile,  # Archivo desde donde extraer (ej: un log o un borrador)
    
    [Parameter(Mandatory=$false)]
    [string]$TopicKey = "passive_harvest"  # Filtro para agrupar en histories/
)

$MemoryPath = Join-Path $PSScriptRoot "..\..\..\..\Auto_memory"
$HistoriesPath = Join-Path $MemoryPath "histories"

if (!(Test-Path $SourceFile)) {
    Write-Host "[X] ERROR: El archivo de origen '$SourceFile' no existe." -ForegroundColor Red
    exit
}

Write-Host "--- INICIANDO COSECHA DE MEMORIA (HARVESTER) ---" -ForegroundColor Cyan
Write-Host "Escaneando: $SourceFile`n" -ForegroundColor Gray

# Buscamos bloques que empiecen con ## Key Learnings: o ## Aprendizajes Clave:
$Content = Get-Content $SourceFile -Raw
$Regex = "(?s)## (Key Learnings|Aprendizajes Clave):.*?(?=\r?\n## |\r?\n$|$)"
$RegexMatches = [System.Text.RegularExpressions.Regex]::Matches($Content, $Regex)

if ($RegexMatches.Count -eq 0) {
    Write-Host "[!] No se detectaron bloques de aprendizaje para cosechar." -ForegroundColor Yellow
    exit
}

foreach ($Match in $RegexMatches) {
    $LearningBlock = $Match.Value.Trim()
    $Today = Get-Date -Format "yyyy-MM-dd"
    $TargetFile = Join-Path $HistoriesPath "$($Today)_$($TopicKey).md"
    
    Write-Host "Encontrado bloque para: $TopicKey ..." -NoNewline
    
    # Preparamos el contenido al estilo histories/
    $HistoryEntry = "`n### [$Today] Cosecha Pasiva`n$LearningBlock`n"
    
    if (!(Test-Path $TargetFile)) {
        # Si no existe, creamos el archivo con estructura histories/
        $Header = "# Detalle de Historial: $TopicKey`n`n## What`nCosecha automatica de aprendizajes pasivos.`n`n## Why`nIntegracion de aprendizajes marcados via Protocolo Harvester.`n`n## Where`n$SourceFile`n`n## Learned`n"
        $Header + $HistoryEntry | Out-File -FilePath $TargetFile -Encoding utf8
        Write-Host " [NUEVA HISTORIA CREADA]" -ForegroundColor Green
    } else {
        # Si existe, anexamos
        Add-Content -Path $TargetFile -Value $HistoryEntry -Encoding utf8
        Write-Host " [HISTORIA ACTUALIZADA]" -ForegroundColor Green
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "COSECHA COMPLETADA: $($RegexMatches.Count) bloque(s) procesado(s)." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
