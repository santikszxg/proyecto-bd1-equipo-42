# Proyecto Bases de Datos I – Equipo 42

**Tema:** Sistema de gestión para una cadena de farmacias

Sistema de información para administrar las sucursales, empleados, productos, stock, clientes y ventas de una cadena de farmacias.

## Integrantes
- Lezcano, Axel Antonio
- Ortiz, Santiago Tomas
- Aquino, Carlos Paul
- Sandoval, Diego Ulises
- Martinez, Juan Esteban

---

## Índice del proyecto

### Etapa 1 – Definición del caso
- [Descripción del caso](docs/etapa-01/descripcion-caso.md)
- [Alcance del sistema](docs/etapa-01/alcance.md)
- [Reglas de negocio](docs/etapa-01/reglas-negocio.md)
- [Decisiones de diseño](docs/etapa-01/decisiones-diseno.md)

### Etapa 2 – Modelado
- [DER](docs/etapa-02/der.png)
- [DER v01](docs/etapa-02/DER-v01.png)
- [Modelo relacional](docs/etapa-02/modelo-relacional.md)
- [Modelo relacional v03 (imagen)](docs/etapa-02/Modelo_relacional_v03.png)
- [Modelo de tablas](docs/etapa-02/modelos_tablas.webp)
- [Normalización](docs/etapa-02/normalizacion.md.txt)
- [Decisiones de diseño](docs/etapa-02/decisiones-diseno.md)

### Etapa 3 – Implementación
- [Implementación](docs/etapa-03/implementacion.md.txt)
- [Restricciones de integridad](docs/etapa-03/restricciones-integridad.md.txt)
- [Pruebas y validación](docs/etapa-03/pruebas-validacion.md.txt)

### Etapa 4 – Consultas y reportes
- [Casos de uso](docs/etapa-04/casos-uso.md.txt)
- [Comprobante de venta](docs/etapa-04/comprobante.venta.md.txt)
- [Consulta avanzada](docs/etapa-04/consulta-avanzada.md.txt)
- [Informe de ventas](docs/etapa-04/informe-ventas.md.txt)

### Etapa 5 – Funcionalidades avanzadas
- [Índices y optimización](docs/etapa-05/indices.optimizacion.md.txt)
- [Procedimientos y funciones](docs/etapa-05/procedimiento-funciones.md.txt)
- [Transacciones](docs/etapa-05/transacciones.md.txt)
- [Triggers y auditoría](docs/etapa-05/triggers.auditoria.md.txt)
- [Seguridad](docs/etapa-05/seguridad.md.txt)

---

## Scripts SQL

### Estructura de la base de datos
- [Creación de la base de datos (DDL)](sql/ddl/crear_bd.sql.txt)

### Datos de prueba
- [Carga de datos de prueba (DML)](sql/dml/datos_prueba.sql.txt)

### Consultas
- [Comprobante de venta](sql/consultas/comprobante_venta.sql.txt)
- [Consulta avanzada](sql/consultas/consulta_avanzada.sql.txt)
- [Informe de ventas](sql/consultas/informe_ventas.sql.txt)

### Objetos técnicos
- [Funciones](sql/tecnico/funciones/)
- [Procedimientos](sql/tecnico/procedimientos/)
- [Transacciones](sql/tecnico/transacciones/)
- [Triggers](sql/tecnico/triggers/)
- [Seguridad](sql/tecnico/seguridad/)

---

## Estructura del repositorio

```
proyecto-bd1-equipo-42/
├── README.md
├── docs/
│   ├── etapa-01/   → Definición del caso
│   ├── etapa-02/   → DER, modelo relacional y normalización
│   ├── etapa-03/   → Implementación y restricciones
│   ├── etapa-04/   → Consultas y reportes
│   └── etapa-05/   → Índices, transacciones, triggers y seguridad
└── sql/
    ├── ddl/        → Creación de la base de datos
    ├── dml/        → Datos de prueba
    ├── consultas/  → Consultas y reportes
    └── tecnico/    → Funciones, procedimientos, transacciones, triggers y seguridad
```
