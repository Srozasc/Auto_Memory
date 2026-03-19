# Auto_Memory Skill 🧠

Un sistema de memoria estratégica, modular y portable para agentes de IA desarrollado para evitar la amnesia episódica durante proyectos de larga duración. Inspirado en repositorios de memoria avanzados, pero diseñado para ser totalmente independiente, sin necesidad de servidores MCP ni dependencias complejas. 

Esta skill dota a los agentes de IA de la capacidad para recordar decisiones técnicas, llevar un control de estado entre sesiones ("relevo") y capturar descrubrimientos clave de forma automática.

## 📁 Estructura del Skill

El proyecto del skill se organiza de forma autónoma dentro de la carpeta del propio skill (`.agent/skills/auto_memory/`):

```text
auto_memory/
├── SKILL.md         # Instrucciones CORE («Prompt» base) que el agente lee al cargar el skill
├── README.md        # Este archivo
├── docs/            # Manuales detallados para cada herramienta (Lazy-loaded por el agente)
│   ├── tool_doctor.md
│   ├── tool_harvest.md
│   ├── tool_stats.md
│   ├── tool_suggest_key.md
│   └── tool_timeline.md
└── scripts/         # Herramientas operativas (PowerShell "Zero-Install")
    ├── doctor.ps1
    ├── harvest.ps1
    ├── stats.ps1
    ├── suggest-key.ps1
    └── timeline.ps1
```

*(Nota: La base de datos / conocimiento generado por el skill se guarda en la carpeta superior raíz del proyecto en `Auto_memory/`)*

## 🚀 Cómo funciona

### 1. Instrucciones del Agente (`SKILL.md`)
Cuando un agente carga este skill, lee automáticamente `SKILL.md`. Este archivo define la misión del agente, la estructura de la memoria y las Reglas de Operación Críticas (como el ritual de "Session Start" y "Session End").

### 2. Manuales "Lazy-Loaded" (`docs/`)
Para no saturar la ventana de contexto inicial del agente de IA, las instrucciones de cómo usar cada script están separadas en manuales individuales. El agente las lee dinámicamente (`view_file`) solo cuando decide utilizar una herramienta específica.

### 3. Herramientas Operativas (`scripts/`)
Scripts de PowerShell diseñados para funcionar en Windows sin configuraciones complejas ni instalaciones de paquetes. 

*   **The Harvester (`harvest.ps1`)**: Extrae silenciosamente bloques de aprendizaje (`## Key Learnings:`) desde notas de sesión y los consolida en historias temáticas.
*   **Memory Doctor (`doctor.ps1`)**: Auditor de integridad. Valida que todo archivo existan, detecta enlaces rotos en los índices y comprueba que contengan la estructura obligatoria (`What`, `Why`, `Where`, `Learned`).
*   **The Dashboard (`stats.ps1`)**: Muestra el progreso estratégico y estadísticas del volumen de conocimiento de las sesiones y temas.
*   **Topic Suggester (`suggest-key.ps1`)**: Ayuda al agente a evitar la duplicación sugiriendo "Topic Keys" similares basándose en el historial existente (Ej: hacer *upsert* en `auth_refactor.md` en lugar de crear un archivo nuevo para cada login).
*   **The Cronoscope (`timeline.ps1`)**: Genera una vista de línea de tiempo consolidando los hitos registrados y las sesiones de forma cronológica.

## 📖 Reglas de Memoria (El Protocolo)

El skill fuerza a los agentes a mantener un flujo de trabajo muy riguroso:
1. **Inicio de Sesión (Session Start)**: El agente lee `LAST_SUMMARY.md` de la sesión anterior para retomar inmediatamente el contexto.
2. **Topic Keys**: Consultar o crear temas únicos de almacenamiento (`suggest-key.ps1`) evitando esparcir archivos desconectados.
3. **Estructura Estricta**: Cada historia registrada documenta el *Por Qué* (Why), *Qué* (What), *Dónde* (Where) y *Aprendizajes* (Learned).
4. **Cierre de Sesión (Session End)**: Se obliga a crear un resumen claro en `sessions/` con lo Completado, Descubierto y lo Pendiente para el próximo agente.
