# PDR — Marketplace Agrícola Huila (MVP)

## 1. Contexto y problema

El sistema busca acercar directamente a productores agrícolas y compradores, reduciendo la dependencia de intermediarios que reducen el margen del productor. Cada usuario puede tener un perfil dual (comprador y/o vendedor). Los vendedores publican productos con fotos e información básica; los compradores navegan el catálogo y acceden a los datos de contacto del vendedor para negociar y cerrar la venta fuera de la plataforma.

### ¿Por qué distribuido y no monolítico?

Los distintos servicios tienen perfiles de carga, disponibilidad y consistencia muy diferentes:

- El **catálogo** necesita alta disponibilidad y tolera lectura ligeramente desactualizada (muchas lecturas, pocas escrituras).
- La **autenticación** necesita consistencia fuerte (no puede haber ambigüedad sobre si un usuario está autenticado).
- Las **calificaciones y notificaciones** pueden procesarse de forma asíncrona y tolerar fallas temporales sin tumbar el resto del sistema.

Separarlos en servicios independientes permite escalar y fallar de forma aislada, en vez de que un pico de tráfico en catálogo o una caída del servicio de notificaciones afecte la autenticación o viceversa.

## 2. Objetivos y alcance

**General:** Permitir el acercamiento directo entre comprador y vendedor de productos agrícolas, reduciendo la necesidad de intermediarios.

**Específicos:**

- Permitir registro y autenticación de usuarios con perfil dual (comprador/vendedor).
- Permitir que el vendedor gestione (crear, editar, eliminar) sus productos publicados.
- Permitir que el comprador navegue y filtre el catálogo de productos disponibles.
- Permitir que comprador y vendedor accedan a la información de contacto del otro para negociar la venta fuera de la plataforma.
- Permitir calificación mutua entre comprador y vendedor tras confirmar que hubo contacto/transacción.
- Notificar por correo eventos relevantes (nuevo contacto, nueva calificación).

**Fuera de alcance (MVP):**

- Gestión de pagos dentro de la plataforma.
- Verificación de identidad (cédula-rostro con IA).
- Logística de transporte o almacenamiento.
- Geolocalización con mapa (solo filtro por municipio/texto).


## 3. Requisitos

### Funcionales

| ID | Descripción |
|----|-------------|
| RF1 | Registro con nombre, correo y contraseña; login con correo/contraseña. |
| RF2 | El usuario elige/cambia su rol activo (comprador/vendedor) desde el menú. |
| RF3 | El vendedor completa perfil de finca: departamento, municipio, vereda, nombre de finca. |
| RF4 | El vendedor puede crear, editar y eliminar productos (nombre, categoría, unidad, cantidad, precio, foto(s), municipio, estado activo/agotado). |
| RF5 | El comprador navega el catálogo con filtro por categoría y municipio. |
| RF6 | Al seleccionar un producto, el comprador ve el detalle y los datos de contacto del vendedor (correo/teléfono). |
| RF7 | Tras contacto, ambas partes pueden confirmar que hubo transacción, habilitando calificación mutua. |
| RF8 | El sistema notifica por correo: nuevo contacto recibido, nueva calificación recibida. |
| RF9 | Reporte básico de perfil/producto sospechoso (revisión manual por admin). |

### No funcionales

- **Disponibilidad:** catálogo y autenticación deben mantenerse operativos aunque calificaciones o notificaciones fallen temporalmente.
- **Latencia:** respuestas de catálogo/auth < 1-2s.
- **Consistencia:** fuerte en autenticación/estado de sesión; eventual en calificaciones y notificaciones.
- **Seguridad:** contraseñas hasheadas (bcrypt), autenticación por JWT.
- **Escalabilidad:** catálogo debe poder escalar horizontalmente de forma independiente a auth.

## 4. Arquitectura preliminar

Servicios: **Auth/Usuarios**, **Catálogo**, **Calificaciones**, **Notificaciones**, con un **API Gateway** al frente. Auth y Catálogo se comunican vía REST síncrono con el gateway; Calificaciones dispara eventos que Notificaciones consume de forma asíncrona vía cola de mensajes.

## 5. Decisiones de diseño clave

- **Comunicación:** REST síncrono para auth/catálogo; asíncrono (cola) para el evento "transacción confirmada" → notificación/habilitación de calificación.
- **Modelo de datos:** una base de datos SQL (Postgres) compartida.
- **CAP:** catálogo prioriza disponibilidad; auth prioriza consistencia.
- **Tolerancia a fallos:** si Notificaciones o Calificaciones caen, el evento queda en cola y se procesa al recuperarse; catálogo/auth siguen funcionando normal.

## 6. Stack tecnológico

- **Java, Spring Boot** 
- **React, Angular** 
- **GO** 
- **PostgreSQL, Mongo**
- **RabbitMQ** 
- **Docker Compose** 

## 7. Riesgos

| Riesgo | Mitigación |
|--------|------------|
| Único desarrollador manteniendo múltiples servicios | Docker Compose local, alcance acotado |
| Calificaciones falsas sin evidencia real de transacción | Confirmación mutua antes de habilitar |
| Scope creep hacia pago/identidad antes de tener el MVP sólido | Fase 2 documentada pero no implementada aún |

## 8. Cronograma

Pendiente de definir hitos 