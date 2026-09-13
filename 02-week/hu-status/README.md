<!-- HU-STATUS TEMPLATE - do NOT remove the <!-- ... --> markers or the table headers.
     Your weekly grade is read AUTOMATICALLY from this file:
       02-week/hu-status/README.md  (inside YOUR fork). English. -->

# Weekly Status - Week 02

<!-- CONFIG-START - must match your profile repo (username/username) CONFIG -->
- FULL_NAME: Alejandro Ortiz Vargas
- GITHUB_USER: alejandro538
- TEAM: Marketplace Agrícola Huila
- SPRINT_GOAL: Definir la arquitectura base (PDR) y alinear las metodologías de trabajo (Scrum/Kanban) para el MVP.
<!-- CONFIG-END -->

## 1. User stories worked this week
| HU ID | Title | Status (todo/doing/done) | Evidence (PR or commit URL) |
|---|---|---|---|
| HU-DOC-001 | Redacción de Product Design Record (PDR) | done | [Insertar Link del Commit] |
| HU-DOC-002 | Definición de prácticas Scrum/Kanban | done | [Insertar Link del Commit] |

## 2. My individual contribution
- Elaboración completa del Product Design Record (PDR) para el Marketplace Agrícola, definiendo el contexto, los objetivos, los requerimientos (RF y RNF) y el stack tecnológico (Java, GO, React, PostgreSQL).
- Diseño de la arquitectura preliminar basada en microservicios (Auth, Catálogo, Calificaciones, Notificaciones) para priorizar disponibilidad y escalabilidad independiente.
- Análisis y diferenciación de buenas prácticas entre Scrum y Kanban para la gestión del proyecto.

## 3. Blockers and risks
- Tuvimos un bloqueante técnico con la separación de los microservicios. Surgió la duda de cómo diferenciarlos correctamente para que cada uno tenga su propio esquema de base de datos de forma independiente, evitando el riesgo de correr todos los microservicios apuntando a una única base de datos monolítica compartida.

## 4. Plan for next week
- Iniciar la configuración de los repositorios base para los microservicios de Auth y Catálogo.
- Definir la estrategia técnica para la separación de esquemas en PostgreSQL.
- Levantar el API Gateway de la arquitectura.

## 5. Compliance self-check
- [x] Conventional Commits - `type(scope): summary`
- [ ] Per-environment HU branch + PR to that environment (hu-xxx-dev -> develop, ...)
- [x] Testable acceptance criteria
- [ ] Tests added/updated (unit / integration)
- [x] DDD / hexagonal boundaries respected (domain has no I/O)
- [x] No secrets; config via environment variables

## 6. Evidence links
- [Agrega aquí cualquier enlace a diagramas, PRs o documentos adicionales]
