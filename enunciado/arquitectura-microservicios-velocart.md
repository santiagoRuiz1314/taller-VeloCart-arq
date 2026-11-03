# Arquitectura de Microservicios

**MSc. Feisar Moreno**
*Universidad Autónoma de Bucaramanga – UNAB*

---

## Caso de estudio: VeloCart Global

**VeloCart Global** es una corporación de comercio electrónico en rápida expansión con presencia en Latinoamérica. Actualmente, opera mediante un monolito heredado (*legacy*) que centraliza el catálogo de productos, el procesamiento de órdenes, los pagos, el inventario y la logística de despachos.

Durante las jornadas de ventas masivas (como *CyberMonday* o *Black Friday*), la plataforma experimenta caídas críticas debido al acoplamiento de la base de datos relacional central y al agotamiento de recursos por el tráfico masivo en el módulo de búsqueda y catálogo. Además, la empresa está integrando nuevos operadores logísticos y pasarelas de pago regionales, pero desplegar cambios menores en el monolito requiere extensas sesiones de pruebas y ventanas de mantenimiento nocturnas.

La junta directiva ha aprobado la migración hacia una Arquitectura de Microservicios capaz de escalar, permitir despliegues independientes por equipo y aislar las fallas de componentes externos.

El objetivo del equipo de trabajo es hacer el diseño completo de la arquitectura de microservicios para la plataforma sin desarrollar código fuente. El diseño debe cubrir desde la visión contextual de negocio hasta el detalle de componentes internos definiendo la infraestructura técnica de hardware y software, con su respectiva justificación de selección, para cada microservicio.

El equipo de trabajo debe descomponer el problema e identificar al menos **cuatro (4) microservicios clave** agrupados por sus contextos delimitados.

---

## Requisitos de Diseño Arquitectónico y Diagramación

Se debe elaborar y entregar la documentación gráfica estructurada en tres niveles del modelo C4:

- **Nivel 1:** Debe mostrar el sistema VeloCart Global con sus usuarios principales y sus interacciones con sistemas externos.
- **Nivel 2:** Debe representar las aplicaciones ejecutables y almacenes de datos que conforman la arquitectura:
  - Aplicaciones cliente (Web, App Móvil).
  - Punto de entrada (API Gateway / BFF - Backend-For-Frontend).
  - Los microservicios delimitados de manera independiente.
  - Buses o brokers de eventos asíncronos.
  - Bases de datos independientes para cada microservicio.
- **Nivel 3:** Se debe detallar la estructura interna de los microservicios diseñados:
  - Controladores/*Endpoints* de entrada.
  - Capas de lógica de negocio y servicios del dominio.
  - Adaptadores de persistencia e integración.

---

## Requisitos de Especificación de Hardware y Software (Con Justificación)

El documento entregable debe incluir las matrices detalladas de especificación técnica:

### Infraestructura de Orquestación y Plataforma Central

Se deben seleccionar y justificar técnicamente las tecnologías generales que soportan el ecosistema:

- Software de Orquestación y Gestión de Contenedores.
- API Gateway.
- Service Mesh / Comunicación Este-Oeste o justificación de por qué no se requiere.
- Event Broker / Middleware de Mensajería.
- Herramientas de Observabilidad y Monitoreo.
- Hardware e Infraestructura Física/Nube.

### Especificación para cada uno de los microservicios identificados

- **Software del Microservicio:**
  - Lenguaje de programación y framework.
  - Tipo y motor de Base de Datos justificando por qué responde al patrón de datos del dominio.
  - Protocolos de comunicación interna y externa.
- **Hardware Asignado al Microservicio:**
  - Recursos asignados (CPU Cores, RAM, etc.).
  - Perfil de la instancia de hardware: Optimizada para Cómputo, Optimizada para Memoria o Propósito General.
  - Tipo de Almacenamiento Físico.
  - Políticas y Métricas de Autoescalado Horizontal.

---

## Entregables

El equipo de trabajo debe entregar un informe de arquitectura en formato PDF que contenga:

1. **Documento de Diseño Arquitectónico (Informe Técnico):**
   - Descripción del sistema y definición de los *Bounded Contexts* identificados.
   - Justificación del estilo de comunicación elegido para cada interacción (Síncrono o Asíncrono por Eventos).
2. **Diagramas C4** (Niveles 1, 2 y 3).
3. **Matriz de Selección Tecnológica** (Hardware y Software).
