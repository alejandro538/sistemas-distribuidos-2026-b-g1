<!-- HU-STATUS TEMPLATE - do NOT remove the <!-- ... --> markers or the table headers.
     Your weekly grade is read AUTOMATICALLY from this file:
       04-week/hu-status/README.md  (inside YOUR fork). English. -->

# Weekly Status - Week 04

<!-- CONFIG-START - must match your profile repo (username/username) CONFIG -->
- FULL_NAME: Alejandro Ortiz Vargas
- GITHUB_USER: alejandro538
- TEAM: Marketplace Agrícola Huila
- SPRINT_GOAL: Definir los límites de dominios (Bounded Contexts) y estructurar los repositorios transversales e infraestructura del MVP.
<!-- CONFIG-END -->

## 1. User stories worked this week
| HU ID | Title | Status (todo/doing/done) | Evidence (PR or commit URL) |
|---|---|---|---|
| HU-DOC-003 | Definición de Límites y Estructura de Dominios (Bounded Contexts) | done | [Insertar Link del Commit] |
| HU-DOC-004 | Definición de Repositorios Transversales e Infraestructura | done | [Insertar Link del Commit] |

## 2. My individual contribution
- Identifiqué y documenté los límites de los 5 dominios principales (Autenticación, Catálogo, Chat, Transacciones y Notificaciones), definiendo sus responsabilidades, lenguaje ubicuo, límites técnicos y bases de datos.
- Establecí las reglas de integración y patrones de comunicación entre microservicios (REST síncrono, WebSockets para chat en tiempo real con Go/MongoDB, y asíncrono con RabbitMQ).
- Diseñé la estructura de repositorios transversales, definiendo módulos específicos para el API Gateway, el Event Broker (RabbitMQ), la infraestructura de bases de datos, orquestación (Docker Compose) y los contratos compartidos (DTOs).

## 3. Blockers and risks
- Se identificó y documentó un riesgo de infraestructura a nivel de base de datos: aunque existe un aislamiento lógico mediante esquemas independientes (`auth`, `catalog`, `transactions`, `notifications`), se utilizará una única instancia física de PostgreSQL. Una caída del motor físico impactará simultáneamente a los dominios relacionales (riesgo aceptado para el alcance del MVP).

## 4. Plan for next week
- Construir el archivo base de `docker-compose.yml` en el `repo-orchestration` para levantar las bases de datos (PostgreSQL, MongoDB) y RabbitMQ.
- Inicializar el `repo-shared-commons` con las estructuras básicas de eventos JSON y utilidades.
- Iniciar la configuración del `repo-api-gateway` para el ruteo básico.

## 5. Compliance self-check
- [x] Conventional Commits - `type(scope): summary`
- [ ] Per-environment HU branch + PR to that environment (hu-xxx-dev -> develop, ...)
- [x] Testable acceptance criteria
- [ ] Tests added/updated (unit / integration)
- [x] DDD / hexagonal boundaries respected (domain has no I/O)
- [x] No secrets; config via environment variables

## 6. Evidence links
- [Agrega aquí cualquier enlace a diagramas, PRs o documentos adicionales]
