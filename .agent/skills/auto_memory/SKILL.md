# Skill: Auto_Memory (Modular & Portable)

## 🎯 Misión
Eres un agente con memoria estratégica. Tu objetivo es registrar hitos, decisiones y lecciones en la carpeta `Auto_memory/` (ubicada en la raíz del proyecto).

## 🧩 Carpeta de Memoria
- `Auto_memory/histories/`: Archivos temáticos (Topic Keys).
- `Auto_memory/sessions/`: Resúmenes de relevo cronológicos.
- `Auto_memory/INDEX_*.md`: Índices de navegación.

## 🛠️ Catálogo de Herramientas (Lazy-Loaded)
Para usar una herramienta, **DEBES leer su manual detallado** en `.agent/skills/auto_memory/docs/` usando `view_file` antes de ejecutar el script.

1. **The Harvester** (`harvest.ps1`): Cosecha automática de lecciones. Manual: `docs/tool_harvest.md`.
2. **The Dashboard** (`stats.ps1`): Progreso del proyecto en tiempo real. Manual: `docs/tool_stats.md`.
3. **The Cronoscope** (`timeline.ps1`): Línea de tiempo unificada. Manual: `docs/tool_timeline.md`.
4. **Memory Doctor** (`doctor.ps1`): Auditoría de integridad. Manual: `docs/tool_doctor.md`.
5. **Topic Suggester** (`suggest-key.ps1`): Guía de taxonomía. Manual: `docs/tool_suggest_key.md`.

## 📜 Reglas de Operación (Portabilidad Total)
1. **Rutas Relativas**: Nunca uses letras de unidad (ej. `D:/`). Usa RUTAS RELATIVAS a la raíz del proyecto.
2. **Upsert en Topics**: No crees 10 archivos para el mismo tema. Usa `suggest-key.ps1` y anexa contenido al archivo existente.
3. **Inicio de Sesión (Session Start)**: Al comenzar, lee `Auto_memory/sessions/LAST_SUMMARY.md` (o el archivo `.md` más reciente en `sessions/`) para retomar desde donde se quedó el agente anterior.
4. **Estructura Obligatoria en Histories**: Todo archivo en `histories/` debe incluir las secciones `## What`, `## Why`, `## Where` y `## Learned`. Ver detalles en `Auto_memory/MEMORY_PROTOCOL.md`.
5. **Cierre de Sesión**: Obligatorio crear un resumen en `sessions/` antes de terminar tu tarea. Usa la estructura: `## Goal`, `## Accomplished`, `## Pending`, `## Discoveries`, `## Relevant Files`.
