# Arquitectura de Microservicios

*MSc. Feisar Moreno*

---

## Introducción y Definición (I)

La arquitectura de microservicios es un enfoque de diseño en el que una aplicación (usualmente grande) se construye como un conjunto de servicios independientes especializados.

A diferencia de las arquitecturas "monolíticas", en las que todo el sistema se desarrolla y despliega como un único bloque, en los microservicios cada componente funciona de forma autónoma.

> **Diagrama: Monolito vs. Microservicios**
>
> - **Monolito:** una sola lógica de aplicación con capas apiladas (UI → Business Logic → Data Access Layer → Integration) que acceden a una **base de datos compartida** (almacenamiento centralizado).
> - **Microservicios:** las apps cliente se comunican (vía API Gateway, Event Bus o comunicación entre servicios) con servicios independientes, cada uno en su propio *Bounded Context* y con su propia base de datos:
>   - **User Service** (gestión de usuarios, autenticación) → User DB
>   - **Order Service** (procesamiento de pedidos, seguimiento) → Order DB
>   - **Product Service** (catálogo, inventario) → Product DB
>   - **Payment Service** (transacciones, facturación) → Payment DB

---

## Introducción y Definición (II)

### Servicios Autónomos y Acotados
- Modelados estrictamente alrededor de un dominio de negocio.
- Independientemente desplegables sin afectar otros componentes.
- Reducen el costo de coordinación entre equipos de desarrollo.

### Encapsulamiento de Detalles
- Ocultan totalmente su lógica e implementación interna.
- Prohibida la exposición de esquemas de bases de datos.
- Comunicación exclusiva mediante contratos de API bien definidos.

### Cultura de Automatización
- Integración y Despliegue Continuo (CI/CD) esperado.
- Pruebas automatizadas de contratos y de integración.
- Infraestructura como Código (IaC) para provisión elástica.

### Aislamiento y Resiliencia
- Fallos aislados que previenen la caída total de la aplicación.
- Despliegues con cero tiempo de inactividad (*Zero-Downtime*).
- Evolución tecnológica independiente por cada servicio.

---

## Alineación con el Negocio

### Ley de Conway
- "Las organizaciones diseñan sistemas que reflejan sus estructuras de comunicación."
- Para lograr sistemas desacoplados, los equipos deben organizarse en torno a capacidades de negocio.
- Se debe buscar evitar silos tecnológicos (*frontend* / *backend* / DBA).

### *Bounded Context* (DDD)
- Fronteras explícitas del modelo de dominio de negocio.
- Define los límites exactos de responsabilidad de cada microservicio.
- Garantiza un lenguaje ubicuo sin ambigüedades entre negocio y desarrollo.

### Regla de las Dos Pizzas
- Equipos pequeños e independientes (5 a 9 personas).
- Propietarios directos del ciclo de vida completo (*You build it, you run it*).
- Maximizan la velocidad de entrega y reducen reuniones de sincronización.

---

## Estructuras Arquitectónicas (I)

### Comunicación Síncrona (*Request - Response*)
- **Protocolos:** REST (HTTP/JSON), gRPC.
- **Mecanismo:** El emisor bloquea la ejecución esperando la respuesta del receptor.
- **Acoplamiento:** Alto acoplamiento temporal entre servicios.
- **Riesgos:** Latencia acumulada y fallos en cascada (*Cascading Failures*).
- **Uso ideal:** Consultas puntuales de baja latencia donde la respuesta es inmediata.

> **Diagrama:** Servicio A —(HTTP REST Request)→ Servicio B —(Llamada interna)→ Servicio C; cada uno espera la *Response* del siguiente.

---

## Estructuras Arquitectónicas (II)

### Comunicación Asíncrona (*Event-Driven* / EDM)
- **Protocolos / *Brokers*:** Apache Kafka, RabbitMQ, NATS.
- **Mecanismo:** Producción y consumo de eventos desacoplados.
- **Acoplamiento:** Desacoplamiento temporal y espacial total.
- **Beneficios:** Alta tolerancia a fallos, *buffering* natural y escalabilidad.
- **Uso ideal:** Flujos de trabajo entre dominios y procesamiento en tiempo real.

> **Diagrama:** Servicio A —(Publicar evento)→ **Event Broker** (Kafka / RabbitMQ) —(Consumir evento)→ Servicio B y Servicio C, cada uno a su propio ritmo.

---

## Datos Distribuidos

### *Database per Microservice*
- Cada microservicio es dueño único de su almacenamiento de datos. Prohibido compartir bases de datos relacionales únicas.
- Evita acoplamiento oculto a nivel de esquema y permite elegir el motor de datos idóneo en cada caso (Relacional, NoSQL, Cache).

### Manejo de Estado y Almacenamiento Local
- Uso de motores de estado internos/embebidos de alto rendimiento para el manejo de *streams*.
- Diferenciación entre almacenes de estado de procesamiento en tiempo real y bases de datos analíticas externas.

### CQRS y *Event Sourcing*
- **CQRS (*Command Query Responsibility Segregation*):** Separa modelos de lectura optimizada y modelos de escritura.
- ***Event Sourcing*:** Persiste los cambios como una secuencia inmutable de eventos en lugar de actualizar el estado actual.

---

## Coordinación de Flujos de Trabajo (I)

### Orquestación
- Un orquestador central coordina el flujo paso a paso.
- **Ventaja:** Visualización clara del estado global del proceso.
- **Desventaja:** Riesgo de crear un "monolito distribuido" y un punto único de fallo.
- Ideal para procesos de negocio complejos y síncronos.

> **Diagrama:** Un *Orchestrator Service* envía comandos directos (*Direct Command* / *Controlled Workflow*) a Service 1, 2 y 3, y recibe de cada uno su *Response/Status*.

---

## Coordinación de Flujos de Trabajo (II)

### Coreografía
- Cada microservicio escucha eventos y reacciona de forma autónoma.
- **Ventaja:** Desacoplamiento máximo y alta escalabilidad.
- **Desventaja:** Dificultad para rastrear el flujo completo y detectar errores.
- Ideal para sistemas altamente distribuidos e impulsados por eventos.

> **Diagrama:** Service 1, 2 y 3 publican y se suscriben a un **Shared Event Bus**; cada uno reacciona de forma autónoma (*Autonomous Reaction*) a los eventos de los demás, sin coordinador central.

---

## Coordinación de Flujos de Trabajo (III)

### Patrón Saga

El patrón Saga es un patrón de diseño que gestiona transacciones distribuidas en arquitecturas de microservicios mediante una secuencia de transacciones locales independientes. Su funcionamiento consta de:

- **Transacción local:** Cada microservicio ejecuta su propia transacción de forma atómica sobre su base de datos particular.
- **Encadenamiento:** Al completar su paso, el servicio publica un evento o envía un mensaje para activar la siguiente transacción local en el siguiente servicio.
- **Consistencia eventual:** En lugar de bloquear recursos globalmente (como haría una transacción ACID tradicional), la saga acepta la consistencia eventual para priorizar rendimiento y disponibilidad.
- **Transacciones compensatorias:** Si un paso falla a mitad de la secuencia, la saga ejecuta acciones de reversión (transacciones compensatorias) en orden inverso para deshacer los cambios ya realizados y restaurar la coherencia de los datos.

---

## Ventajas y Desafíos

### Reducción de Costos de Coordinación
- Elimina cuellos de botella en equipos grandes.
- Permite despliegues en paralelo sin sincronización masiva.
- Iteración rápida alineada a objetivos de negocio específicos.

### Escalabilidad Elástica y Localizada
- Escalado independiente únicamente del servicio bajo alta carga.
- Uso eficiente de cómputo y memoria sin replicar todo el sistema.
- Optimización de costos operativos de infraestructura en la nube.

### Despliegue Independiente y Seguro
- Cambios pequeños con mínimo radio de impacto (*Blast Radius*).
- Facilidad de *Rollback* localizado en caso de anomalías.
- Soporte nativo para estrategias *Blue-Green* y *Canary*.

### Heterogeneidad Tecnológica (*Polyglot*)
- Elección del lenguaje y *framework* ideal para cada servicio.
- Adopción de motores de datos especializados (Relacional, Documentos, Grafos).
- Facilita la experimentación tecnológica sin reemplazar todo el *stack*.

---

## Costos y Complejidad Distribuida

### El "Microservice Tax"
- Alto costo inicial en infraestructura, CI/CD y redes.
- Inversión obligatoria en observabilidad (Trazabilidad, Métricas, Logs).
- Mayor complejidad de gestión y gobernanza de APIs.

### Complejidad de Red
- Llamadas de red sustituyen llamadas a memoria local.
- Latencias acumuladas, descalibres de reloj y paquetes perdidos.
- Necesidad de diseñar para el fallo (*Circuit Breakers*, *Retries*).

### Consistencia Eventual
- Pérdida de la simplicidad de transacciones ACID relacionales.
- Manejo complejo de datos duplicados y vistas desactualizadas.
- Dificultad para mantener integridad referencial global.

### Bucles de Retroalimentación Extensos
- Dificultad para reproducir errores en entornos locales.
- Pruebas de integración más complejas e inciertas.
- Comportamiento emergente difícil de diagnosticar.

---

## Ecosistema Tecnológico - Software

### Contenedores
- Docker.
- Empaquetado aislado de código, binarios y dependencias.
- Inmutabilidad entre entornos de desarrollo y producción.
- Aislamiento de recursos a nivel de SO.

### Orquestación (CMS)
- Kubernetes, Amazon ECS.
- Programación automática de cargas en clústeres.
- *Auto-repair* (Heal), *Auto-scaling* horizontal (HPA).
- Descubrimiento de servicios y balanceo nativo.

### *Service Mesh*
- Istio, Linkerd (patrón *Sidecar*).
- Desacopla resiliencia del código de aplicación.
- Cifrado mTLS, *Circuit Breakers* e Inyección de Fallos.
- Trazabilidad distribuida transparente.

### *Serverless* / FaaS
- AWS Lambda, Cloud Run.
- Cómputo efímero orientado a eventos.
- Escalado instantáneo a cero y pago por ejecución.
- Abstracción total de gestión de servidores.

---

## Ecosistema Tecnológico - Hardware

### *Commodity Hardware* en Clúster
- Servidores estándar de bajo costo agrupados en clústeres elásticos.
- Sustituye a los *Mainframes* o servidores verticales costosos.
- Tolerancia nativa a fallos de hardware mediante redundancia de software.

### Nodos Especializados
- **Instancias intensivas en Memoria:** Para cachés distribuidas (Redis) y procesamiento de *streams* (Kafka).
- **Instancias intensivas en CPU:** Para algoritmos intensivos y cómputo de alta velocidad.
- Alineación precisa de hardware con el perfil del microservicio.

### Estrategia de Almacenamiento Físico
- **Discos Locales SSD / NVMe:** Baja latencia para motores de estado internos.
- **Discos Adjuntos por Red (NAS / EBS):** Flexibilidad y persistencia independiente del ciclo de vida del nodo.
- *Trade-off* claro entre latencia de E/S y volatilidad.

---

## Estrategias de Migración (I)

### Patrón *Strangler Fig*
- Estrategia de migración gradual desde el monolito.
- Un API *Gateway / Proxy* enruta peticiones progresivamente a los nuevos microservicios.
- El monolito se divide en trozos pequeños hasta desaparecer sin *Big Bangs*.

> **Diagrama:** El tráfico del cliente llega a un **API Router / Proxy**. Las rutas *legacy* van al **Monolith** (con su Legacy DB); las nuevas rutas migradas van a **Microservice A** y **Microservice B**, cada uno con su propia base de datos (New DB A, New DB B). La Legacy DB alimenta las nuevas bases mediante **CDC (Change Data Capture)**.

---

## Estrategias de Migración (II)

### *Data Liberation* (CDC)
- **Change Data Capture (ej. Debezium):** Captura cambios directos en la BD del monolito.
- Publica eventos en tiempo real hacia el *Event Broker* sin modificar el código *legacy*.
- Alimenta los nuevos microservicios con datos frescos de forma transparente.

### Ejemplo
Sistema de Reservas / *E-Commerce*:
- Servicio de Búsqueda (NoSQL + Cache)
- Servicio de Reservas (Consistencia Estricta)
- Servicio de Pagos (Saga / Integración)
- Servicio de Notificaciones (Eventos Asíncronos)

---

## Conclusiones

1. **No comiences con microservicios si no los necesitas**
   Si no requieres escalar componentes individualmente ni reducir fricción entre múltiples equipos, un Monolito Bien Estructurado es más rápido y económico.

2. **Modela alrededor de dominios, no capas tecnológicas**
   Los microservicios organizados por capas (ej. servicio de UI, servicio de BD) crean acoplamiento extremo. Modela siempre alrededor de *Bounded Contexts* de negocio.

3. **Automatiza la infraestructura antes de multiplicar servicios**
   Sin *pipelines* automáticos de CI/CD, observabilidad centralizada e infraestructura como código, gestionar decenas de microservicios se vuelve inmanejable.
