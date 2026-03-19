# Manual de Herramienta: Topic Suggester (Sugerencia de Claves)

## Propósito
Ayuda a evitar duplicados en la memoria sugiriendo claves de tema (Topic Keys) ya existentes.

## Sintaxis (Powershell)
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".agent/skills/auto_memory/scripts/suggest-key.ps1" -Query "<PalabraClave>"
```

## Cuándo usarla
- **Imprescindible** antes de crear un nuevo historial en `Auto_memory/histories/`.
- Permite descubrir si un concepto (ej. "auth") ya fue tratado por un agente previo.
