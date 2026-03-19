# Auto_Memory Topic Suggester - Orquestador de Temas
# Mision: Mantener una taxonomia limpia y coherente de memorias evitando duplicados.

param(
    [Parameter(Mandatory=$false)]
    [string]$Query  # Palabra clave para buscar similitudes
)

$HistoriesPath = Join-Path $PSScriptRoot "..\..\..\..\Auto_memory\histories"

if (!(Test-Path $HistoriesPath)) {
    Write-Host "[X] ERROR: No se encuentra la carpeta de historias." -ForegroundColor Red
    exit
}

Write-Host "--- AUTO_MEMORY TOPIC SUGGESTER ---" -ForegroundColor Cyan

# Obtenemos todas las Topic Keys (nombres de archivo sin extension ni fecha)
$Files = Get-ChildItem -Path $HistoriesPath -Filter "*.md"
$ExistingKeys = @()

foreach ($File in $Files) {
    # Removemos la fecha YYYY-MM-DD y la extension
    $CleanName = $File.BaseName -replace "^\d{4}-\d{2}-\d{2}_", ""
    $ExistingKeys += [PSCustomObject]@{
        Key = $CleanName
        File = $File.Name
    }
}

if ($Query) {
    $SafeQuery = [regex]::Escape($Query)  # Previene bugs con chars especiales de regex (ej: "auth.service")
    Write-Host "Búscando coincidencias para: '$Query' ..." -ForegroundColor Gray
    $RegexMatches = $ExistingKeys | Where-Object { $_.Key -like "*$Query*" -or $_.Key -match $SafeQuery }
    
    if ($RegexMatches.Count -gt 0) {
        Write-Host "`n[!] SE ENCONTRARON TEMAS RELACIONADOS:" -ForegroundColor Green
        $RegexMatches | Format-Table -Property Key -HideTableHeaders
        Write-Host "Recomendación: Usa una de estas claves (Upsert) en lugar de crear una nueva." -ForegroundColor Yellow
    } else {
        Write-Host "`n[OK] No hay temas similares. Puedes crear uno nuevo." -ForegroundColor Green
        $Slug = ($Query.ToLower() -replace "[^a-z0-9]", "_").Trim("_")
        Write-Host "Sugerencia de nueva clave: $Slug" -ForegroundColor Cyan
    }
} else {
    Write-Host "`nTEMAS REGISTRADOS ACTUALMENTE EN EL CEREBRO:" -ForegroundColor Yellow
    $ExistingKeys.Key | Select-Object -Unique | Sort-Object | ForEach-Object { Write-Host "  - $_" }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
