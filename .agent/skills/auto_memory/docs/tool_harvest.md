# Manual de Herramienta: The Harvester (Cosecha Pasiva)

## Propósito
Extrae automáticamente lecciones marcadas con `## Key Learnings:` en archivos de texto.

## Sintaxis (Powershell)
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".agent/skills/auto_memory/scripts/harvest.ps1" -SourceFile "<RutaAlArchivo>" -TopicKey "<TemaOpcional>"
```

## Flujo Completo de Uso (2 Pasos)
El Harvester requiere un flujo de 2 pasos que el agente debe seguir:

**Paso 1 — Marcar aprendizajes durante la sesión:**
Al finalizar una tarea compleja, escribe (o dicta a un archivo temporal) una sección así:
```markdown
## Key Learnings:
- Aprendizaje 1 descubierto durante esta sesión.
- Aprendizaje 2 con contexto específico.
```

**Paso 2 — Cosechar al cerrar la sesión:**
Ejecuta el Harvester apuntando al archivo donde marcaste los aprendizajes:
```powershell
powershell.exe -ExecutionPolicy Bypass -File ".agent/skills/auto_memory/scripts/harvest.ps1" -SourceFile "tmp_session_notes.md" -TopicKey "auth_refactor"
```

## Reglas de Uso
- El parámetro `-SourceFile` es **obligatorio**.
- El archivo de origen debe ser accesible desde la raíz del proyecto.
- Si no hay coincidencias, el script avisará y no creará nada.
- El `-TopicKey` debe ser consultado antes con `suggest-key.ps1` para evitar duplicados.
