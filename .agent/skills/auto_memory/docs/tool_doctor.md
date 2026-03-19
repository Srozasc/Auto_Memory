# Manual de Herramienta: Memory Doctor (Auditor de Integridad)

## Propósito
Detecta enlaces rotos en los índices y valida la estructura de la memoria.

## Sintaxis (Powershell)
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".agent/skills/auto_memory/scripts/doctor.ps1"
```

## Reporte
- **OK**: El enlace apunta a un archivo que existe.
- **[X] ERROR**: El archivo referenciado en un índice no se encuentra en el filesystem.
- **[!] Huérfano**: Archivo en `histories/` que no está en ningún índice.

## Guía de Remediación (Qué hacer ante cada caso)

| Situación | Acción Recomendada |
|-----------|-------------------|
| `[X] ERROR` — enlace roto en índice | Actualiza el `INDEX_*.md` para corregir la ruta, o crea el archivo faltante. |
| `[!] Huérfano` — archivo sin índice | Agrega una entrada al `INDEX_features.md` o `INDEX_milestones.md` según corresponda. |
| Secciones faltantes (`What`/`Why`/`Where`/`Learned`) | Abre el archivo de historia indicado y completa las secciones obligatorias definidas en `MEMORY_PROTOCOL.md`. |
