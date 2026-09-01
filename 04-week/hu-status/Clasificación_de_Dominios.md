# Análisis de Límites y Estructura de Dominios (Bounded Contexts)
## Marketplace Agrícola Huila (MVP)

---

## 1. Introducción y Contexto General

El presente documento establece la identificación, estructura y límites de los **dominios de dominio (Bounded Contexts)** para el **Marketplace Agrícola Huila (MVP)** [cite: 1]. El objetivo fundamental de la plataforma es eliminar o reducir intermediarios en la cadena comercial agropecuaria, conectando de manera directa a los **productores agrícolas** del departamento del Huila con sus **compradores** [cite: 1].

Dado que los distintos submódulos del sistema demandan perfiles heterogéneos de **disponibilidad, latencia y consistencia**, el sistema se diseñó bajo una arquitectura distribuida orientada a microservicios [cite: 1]. Esta división permite aislar los fallos, garantizar escalabilidad independiente y delimitar las responsabilidades funcionales y de datos de cada dominio [cite: 1].

---

## 2. Resumen Estratégico de Dominios

La siguiente tabla sintetiza la estructuración de los dominios identificados en el PDR, detallando su tecnología, persistencia, patrón de comunicación y modelo de consistencia [cite: 1].

| Dominio / Bounded Context | Responsabilidad Principal | Backend | Base de Datos / Schema | Comunicación | Atributo de Calidad Prioritario |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Autenticación y Usuarios** | Gestión de identidades, roles únicos e inmutables y perfil de finca [cite: 1]. | Java + Spring Boot [cite: 1] | PostgreSQL (`auth`) [cite: 1] | REST Síncrono [cite: 1] | Consistencia Fuerte [cite: 1] |
| **Catálogo de Productos** | Publicación, edición, consulta y filtrado territorial/categoría de productos [cite: 1]. | Java + Spring Boot [cite: 1] | PostgreSQL (`catalog`) [cite: 1] | REST Síncrono [cite: 1] | Alta Disponibilidad [cite: 1] |
| **Chat y Mensajería** | Comunicación en tiempo real vinculada a productos para la negociación de compras [cite: 1]. | Go [cite: 1] | MongoDB [cite: 1] | WebSocket (Tiempo real) [cite: 1] | Baja Latencia / Alta Concurrencia [cite: 1] |
| **Transacciones y Ledger** | Procesamiento de pagos vía pasarela sandbox, confirmación automática por webhook y ledger interno de dispersión [cite: 1]. | Java + Spring Boot [cite: 1] | PostgreSQL (`transactions`) [cite: 1] | REST Síncrono / Webhook / Event Producer [cite: 1] | Consistencia Fuerte [cite: 1] |
| **Notificaciones** | Envío y registro de alertas asíncronas originadas por eventos del sistema [cite: 1]. | Java + Spring Boot [cite: 1] | PostgreSQL (`notifications`) [cite: 1] | Asíncrono (Cola RabbitMQ) [cite: 1] | Tolerancia a Fallos / Consistencia Eventual [cite: 1] |
| **API Gateway** | Punto único de entrada, enrutamiento de tráfico REST y WebSocket [cite: 1]. | Infraestructura [cite: 1] | N/A | HTTP / WS Proxy [cite: 1] | Ruteo y Seguridad [cite: 1] |

---

## 3. Identificación y Definición de Dominios

### 3.1. Dominio 1: Autenticación y Usuarios (`auth`)

#### A. Responsabilidades y Alcance
Este dominio gestiona el ciclo de vida de la identidad de los usuarios dentro de la plataforma [cite: 1]. Garantiza que cada usuario registrado posea un único rol (Productor o Comprador), el cual permanece **inmutable** durante el MVP [cite: 1]. Adicionalmente, administra el perfil productivo de los productores [cite: 1].

#### B. Lenguaje Ubicuo
* **Usuario:** Entidad principal con credenciales (correo y contraseña hasheada con bcrypt) [cite: 1].
* **Rol:** Tipo de actor en la plataforma (`Productor` o `Comprador`) [cite: 1].
* **Perfil de Finca:** Información territorial de la unidad productiva del productor (Departamento, Municipio, Vereda, Nombre de Finca) [cite: 1].
* **Token JWT:** Mecanismo de autenticación para respaldar las peticiones seguras [cite: 1].

#### C. Límites (Boundaries)
* **Dentro del límite:** Registro de usuario, autenticación (login), emisión de JWT, consulta/actualización del perfil de finca del productor [cite: 1].
* **Fuera del límite:** Validación biométrica o de cédula/rostro mediante IA (Fase 2 / Fuera de alcance) [cite: 1], reputación o calificaciones de usuarios [cite: 1].

#### D. Estructura Técnica y Persistencia
* **Tecnología:** Java + Spring Boot [cite: 1].
* **Persistencia:** PostgreSQL en el schema aislado `auth` [cite: 1].
* **Patrón CAP:** Prioriza **Consistencia Fuerte** [cite: 1].

---

### 3.2. Dominio 2: Catálogo de Productos (`catalog`)

#### A. Responsabilidades y Alcance
Administra la oferta de bienes agrícolas del sistema [cite: 1]. Permite a los productores realizar operaciones CRUD sobre sus publicaciones y a los compradores explorar, buscar y filtrar la oferta disponible [cite: 1].

#### B. Lenguaje Ubicuo
* **Producto:** Bien agrícola ofrecido por un productor [cite: 1].
* **Atributos de Producto:** Nombre, categoría, unidad de medida, cantidad disponible, precio unitario, fotografías, municipio de origen [cite: 1].
* **Estado de Producto:** Disponibilidad del ítem (`Activo` o `Agotado`) [cite: 1].
* **Filtro del Catálogo:** Búsqueda combinada por categoría agrícola y municipio [cite: 1].

#### C. Límites (Boundaries)
* **Dentro del límite:** Creación, modificación, eliminación física/lógica de productos; actualización de estado activo/agotado; navegación y filtrado por categoría y municipio [cite: 1].
* **Fuera del límite:** Geolocalización mediante mapas interactivos (solo se usa texto/municipio) [cite: 1], control automatizado de inventarios descontados por transacciones.

#### D. Estructura Técnica y Persistencia
* **Tecnología:** Java + Spring Boot [cite: 1].
* **Persistencia:** PostgreSQL en el schema aislado `catalog` [cite: 1].
* **Patrón CAP:** Prioriza **Alta Disponibilidad** (tolera lecturas ligeramente desactualizadas debido al patrón de muchas lecturas y pocas escrituras) [cite: 1].

---

### 3.3. Dominio 3: Chat y Mensajería (`chat`)

#### A. Responsabilidades y Alcance
Soporta la interacción directa en tiempo real entre el comprador y el productor, vinculada a un producto específico [cite: 1]. Su propósito central es permitir la negociación del acuerdo comercial, definiendo si la compra se realiza por plataforma o por fuera de ella [cite: 1].

#### B. Lenguaje Ubicuo
* **Conversación / Sala:** Hilo de mensajería iniciado por un comprador con el productor de un producto específico [cite: 1].
* **Mensaje:** Contenido textual enviado en tiempo real entre las partes [cite: 1].
* **Acuerdo de Compra por Plataforma:** Decisión de pagar vía la pasarela integrada [cite: 1].
* **Acuerdo Comercial Externo:** Negociación libre compartiendo datos de contacto (WhatsApp, número de cuenta bancaria) [cite: 1].

#### C. Límites (Boundaries)
* **Dentro del límite:** Creación de hilos de chat asociados a un producto, intercambio de mensajes con baja latencia, emisión del evento `NuevoMensajeChat` [cite: 1].
* **Fuera del límite:** Seguimiento, confirmación o garantía sobre ventas o dinero negociado por fuera de la plataforma (estas quedan bajo responsabilidad directa de las partes) [cite: 1].

#### D. Estructura Técnica y Persistencia
* **Tecnología:** Go (aprovechando goroutines y channels para la alta concurrencia de conexiones simultáneas) [cite: 1].
* **Persistencia:** MongoDB (instancia dedicada con modelo de datos basado en documentos) [cite: 1].
* **Protocolo:** WebSocket a través del API Gateway [cite: 1].

---

### 3.4. Dominio 4: Transacciones y Ledger (`transactions`)

#### A. Responsabilidades y Alcance
Encargado del procesamiento financiero interno y externo de compras realizadas dentro de la plataforma [cite: 1]. Administra la integración en modo sandbox con la pasarela de pago, procesa las confirmaciones automáticas vía webhook y registra contablemente la dispersión de fondos hacia el productor en un ledger interno [cite: 1].

#### B. Lenguaje Ubicuo
* **Transacción:** Registro de intento de compra y pago realizado dentro de la plataforma [cite: 1].
* **Pasarela de Pago (Sandbox):** Servicio externo de procesamiento en entorno de pruebas (sin dinero real) [cite: 1].
* **Webhook de Pasarela:** Notificación HTTP entrante enviada por la pasarela para confirmar automáticamente el pago [cite: 1].
* **Ledger Interno de Dispersión:** Libro contable secundario para registrar y controlar manualmente el reparto/dispersión de fondos al productor [cite: 1].
* **Evento `TransacciónConfirmada`:** Notificación interna que dispara el flujo asíncrono hacia el servicio de notificaciones [cite: 1].

#### C. Límites (Boundaries)
* **Dentro del límite:** Procesamiento de compras en plataforma, recepción de webhooks de pago, registro en ledger interno, emisión del evento `TransacciónConfirmada` [cite: 1].
* **Fuera del límite:** Selección definitiva de pasarela para producción [cite: 1], manejo de dinero real en el MVP [cite: 1], registro o intervención en pagos acordados por fuera de la plataforma [cite: 1].

#### D. Estructura Técnica y Persistencia
* **Tecnología:** Java + Spring Boot [cite: 1].
* **Persistencia:** PostgreSQL en el schema aislado `transactions` [cite: 1].
* **Patrón CAP:** Prioriza **Consistencia Fuerte** (un pago no puede quedar en un estado ambiguo) [cite: 1].

---

### 3.5. Dominio 5: Notificaciones (`notifications`)

#### A. Responsabilidades y Alcance
Procesa de forma asíncrona los eventos relevantes generados por otros dominios, garantizando la alerta oportuna al usuario sin afectar el rendimiento o disponibilidad de los servicios de origen [cite: 1].

#### B. Lenguaje Ubicuo
* **Evento Asíncrono:** Evento de dominio capturado desde el intermediario de mensajería (RabbitMQ) [cite: 1].
* **Notificación de Transacción:** Mensaje generado al confirmarse una compra por plataforma [cite: 1].
* **Notificación de Chat:** Alerta generada al recibir un nuevo mensaje en el chat [cite: 1].

#### C. Límites (Boundaries)
* **Dentro del límite:** Consumo de eventos de cola (`TransacciónConfirmada`, `NuevoMensajeChat`), registro e historial de notificaciones enviadas [cite: 1].
* **Fuera del límite:** Generación síncrona de alertas o bloqueo de transacciones/mensajes si el servicio de notificaciones falla [cite: 1].

#### D. Estructura Técnica y Persistencia
* **Tecnología:** Java + Spring Boot [cite: 1].
* **Persistencia:** PostgreSQL en el schema aislado `notifications` [cite: 1].
* **Infraestructura:** Consumidor de cola de mensajería RabbitMQ [cite: 1].
* **Patrón CAP:** Prioriza **Tolerancia a Fallos** y **Consistencia Eventual** [cite: 1].

---

## 4. Mapa de Contexto e Integración de Dominios

La interacción entre los dominios se organiza combinando patrones **síncronos** (REST / WebSocket) para operaciones inmediatas y **asíncronos** (Event-Driven mediante Broker) para la propagación de eventos [cite: 1].

```
+-----------------------------------------------------------------------------------+
|                                   CLIENTES                                        |
|             [ Marketplace App (React) ]   /   [ Panel Admin (Angular) ]           |
+-----------------------------------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------+
|                                  API GATEWAY                                      |
+-----------------------------------------------------------------------------------+
       |                 |                   |                   |
 (REST | Síncrono) (REST | Síncrono)   (WebSocket | RT)    (REST | Síncrono)
       v                 v                   v                   v
+--------------+  +--------------+    +--------------+    +----------------------+
| Auth / User  |  |   Catálogo   |    | Chat / Msg   |    | Transacciones/Ledger |
| (PostgreSQL) |  | (PostgreSQL) |    |  (MongoDB)   |    |     (PostgreSQL)     |
+--------------+  +--------------+    +--------------+    +----------------------+
                                             |                       |
                                     Produce | Evento        Produce | Evento
                                  `NuevoMensajeChat`     `TransacciónConfirmada`
                                             |                       |
                                             v                       v
                                  +--------------------------------------+
                                  |         RabbitMQ Broker              |
                                  +--------------------------------------+
                                                     |
                                            Consume  | Eventos
                                                     v
                                          +---------------------+
                                          |    Notificaciones   |
                                          |    (PostgreSQL)     |
                                          +---------------------+
```

### Reglas de Integración entre Dominios:
1. **Punto de Entrada:** Toda comunicación desde los clientes pasa por el **API Gateway** [cite: 1].
2. **Autenticación Cross-Cutting:** Los servicios de Catálogo, Chat y Transacciones validan el token JWT emitido originalmente por el servicio de **Auth** [cite: 1].
3. **Desacoplamiento de Notificaciones:** Ningún servicio realiza llamadas síncronas a **Notificaciones**. En su lugar, publican eventos en **RabbitMQ** [cite: 1]. Si Notificaciones cae, los eventos permanecen encolados sin afectar el funcionamiento general del sistema [cite: 1].
4. **Independencia en Compras Externas:** Las conversaciones en **Chat** que acuerden pagos por fuera del sistema no desencadenan ninguna interacción con el dominio de **Transacciones** [cite: 1].

---


## 5. Consideraciones de Arquitectura de Datos y Riesgos

1. **Separación Lógica en PostgreSQL:** 
   A excepción de Chat (MongoDB), los servicios de Auth, Catálogo, Transacciones y Notificaciones comparten una única instancia física de PostgreSQL, pero con **schemas independientes y aislados** (`auth`, `catalog`, `transactions`, `notifications`) [cite: 1].
2. **Aceptación de Riesgo de Infraestructura:** 
   Aunque existe aislamiento lógico a nivel de aplicación, una caída del motor físico de PostgreSQL impactará simultáneamente a los dominios relacionales [cite: 1]. Este riesgo es aceptado conscientemente dentro de la definición del MVP académico [cite: 1].
3. **Manejo de Transacciones Externas:**
   El sistema no garantiza, audita ni ofrece cobertura sobre transacciones acordadas de forma directa entre comprador y productor por fuera de la pasarela [cite: 1]. El dominio de Chat funciona como canal neutro [cite: 1].