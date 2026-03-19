# Manual de Herramienta: The Cronoscope (Timeline)

## Propósito
Visualiza la historia cronológica de hitos y sesiones en una línea de tiempo unificada.

## Sintaxis (Powershell)
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".agent/skills/auto_memory/scripts/timeline.ps1" -Last <NumeroEventos>
```

## Parámetros
- `-Last`: (Opcional) Número de eventos a mostrar (por defecto 10).
- `-DateFilter`: (Opcional) Filtrar por una fecha específica (YYYY-MM-DD).
