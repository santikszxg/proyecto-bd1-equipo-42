+ **NORMALIZACION**

+ Para esta parte del trabajo, se analizaron algunos casos por adelantado en el modelo relacional para evitar trabajo o muchas modificaciones en el modelo.

+ **1RA FN:**
+ Para la primera FN (donde los datos deben mantenerse atómicos), se tuvo que modificar algunas cosas del modelo, como lo es en la tabla de `sucursal` en donde poseía valores
+ multivaluados, como lo era el horario de atencion y rompia la 1.FN. Para solucionar este problema se creo una nueva tabla *"horario_atencion"* la cual volvia a poner en forma
+ al modelo.

+ **2DA FN:**
+ Para la segunda FN (Donde los campos de una tabla deben depender del campo el cual sea PK, ademas de estar en 1FN), Para solucionar este problema en el modelo Relacional, tuvimos que modificar
+ las tablas *"Sucursal"* y *"proveedor"* esto ya que ambas contenían como campos localidad y direccion las cuales no dependian directamente de la clave primaria de cada tabla
+ independiente, por ende, se desarrolló una nueva tabla *"Ubicacion"*, de esta forma las tablas *"sucursal"* y *"proveedor"* podian mantener un estado mas puro con respecto a
+ sus campos, y cumpliendo con la 2da.FN.

+ **3RA FN:**
+ Para el desarrollo de la tercera FN no tuvimos ningun inconveniente, debido a que ningun campo no clave primaria (PK) de cualquier tabla independiente tuvo conflictos con otro campo no clave (PK).
