# Repositorios Transversales e Infraestructura — Marketplace Agrícola Huila (MVP)

## 1. Resumen Estratégico de Repositorios Transversales

Para preservar la autonomía de los dominios de negocio y evitar el acoplamiento directo entre microservicios, se definen los siguientes componentes e infraestructuras transversales[cite: 1, 2]:

| Repositorio / Módulo | Tipo de Componente | Responsabilidad Principal | Stack Tecnológico |
| :--- | :--- | :--- | :--- |
| **`repo-api-gateway`** | API Gateway / Proxy | Entrada única, ruteo HTTP/WS y validación transversal de tokens JWT[cite: 1, 2]. | Infraestructura / Reverse Proxy[cite: 1] |
| **`repo-event-broker`** | Broker / Middleware | Transporte asíncrono y desacoplado de eventos del sistema[cite: 1, 2]. | RabbitMQ[cite: 1, 2] |
| **`repo-database-infra`** | Base de Datos / Persistencia | Scripts DDL para la inicialización de schemas en PostgreSQL y BD de MongoDB[cite: 1, 2]. | PostgreSQL, MongoDB[cite: 1, 2] |
| **`repo-orchestration`** | DevOps / Orquestación | Configuración local unificada para despliegue en entorno de pruebas/MVP[cite: 2]. | Docker Compose[cite: 2] |
| **`repo-shared-commons`** | Librería Compartida | Contratos de integración (DTOs), modelos de eventos JSON y utilidades de seguridad[cite: 1, 2]. | Java / Go / JSON Schema[cite: 1] |

---

## 2. Definición y Alcance de Repositorios Transversales

### 2.1. API Gateway (`repo-api-gateway`)
* **Propósito:** Actuar como fachada de entrada para las aplicaciones cliente (React Marketplace y Panel Admin Angular)[cite: 1, 2].
* **Alcance Técnico:**
  * Enrutamiento síncrono vía REST hacia Auth, Catálogo y Transacciones[cite: 1].
  * Proxy para conexiones bidireccionales en tiempo real mediante WebSocket hacia el servicio de Chat[cite: 1].
  * Verificación transversal de autenticación mediante tokens JWT emitidos por el dominio Auth[cite: 1, 2].

### 2.2. Broker de Eventos y Mensajería (`repo-event-broker`)
* **Propósito:** Ofrecer el bus de comunicación asíncrono para eventos entre dominios[cite: 1, 2].
* **Alcance Técnico:**
  * Configuración de Queues y Exchanges en **RabbitMQ**[cite: 1, 2].
  * Canalización del evento `TransacciónConfirmada` (generado en Transacciones tras webhook de pasarela)[cite: 1, 2].
  * Canalización del evento `NuevoMensajeChat` (generado en Chat al enviar mensajes)[cite: 1, 2].
  * Garantizar la tolerancia a fallos para que el dominio de Notificaciones consuma mensajes sin bloquear operaciones principales[cite: 1, 2].

### 2.3. Infraestructura de Datos y Despliegue (`repo-database-infra` / `repo-orchestration`)
* **Propósito:** Estandarizar el aprovisionamiento de bases de datos y la ejecución local del sistema distribuido[cite: 1, 2].
* **Alcance Técnico:**
  * Declaración de la instancia física compartida de PostgreSQL organizada por schemas independientes: `auth`, `catalog`, `transactions` y `notifications`[cite: 1, 2].
  * Aprovisionamiento del motor MongoDB dedicado exclusivamente al almacenamiento de mensajes y conversaciones del Chat[cite: 1, 2].
  * Scripts de orquestación en **Docker Compose** para levantar los 5 microservicios, el gateway, los 2 motores de bases de datos y RabbitMQ de forma automatizada[cite: 2].

### 2.4. Contratos y DTOs Compartidos (`repo-shared-commons`)
* **Propósito:** Evitar inconsistencias en la estructura de los datos que viajan entre microservicios[cite: 1].
* **Alcance Técnico:**
  * Definición de esquemas de eventos para las colas de RabbitMQ (`TransacciónConfirmada`, `NuevoMensajeChat`)[cite: 1, 2].
  * Reutilización de clases utilitarias para el parseo y validación de tokens JWT en los servicios que lo requieran[cite: 1, 2].