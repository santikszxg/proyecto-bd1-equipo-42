<div align="center">

# 💊 Sistema de Gestión de Farmacias
### Proyecto Integrador — Bases de Datos I (Equipo 42)

<p align="center">
  <img width="200" alt="Vista previa del sistema" src="https://github.com/user-attachments/assets/778b6a3e-119e-44d3-841d-189245212f53" />
</p>

![Status](https://img.shields.io/badge/Estado-En_Desarrollo-blue?style=for-the-badge)
![Database](https://img.shields.io/badge/Base_de_Datos-Relacional-informational?style=for-the-badge)

<p align="center">
  Solución integral para el modelado relacional y la administración de sucursales, inventario, personal y transacciones comerciales en una red de farmacias.
</p>

</div>

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
