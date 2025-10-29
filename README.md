# Proyecto: vuelos_min (PostgreSQL)

Pequeño proyecto para practicar PostgreSQL con un modelo mínimo de **aeropuertos**, **vuelos**, **pasajeros** y **reservas**.

## Estructura del proyecto

```plaintext
vuelos_min/
├─ README.md                ← este archivo
├─ data/
│  ├─ airports.csv
│  ├─ flights.csv
│  ├─ passengers.csv
│  └─ bookings.csv
├─ sql/
│  ├─ 01_schema.sql         ← crea BD y tablas
│  └─ 02_impor.sql          ← inserta datos de ejemplo con SQL (sin CSV)
└─ exports/                 ← aquí quedarán los CSV que exportes
```

## Requisitos

- PostgreSQL instalado (incluye la herramienta **psql**).
- Conocer usuario y contraseña de tu instalación (por defecto, puede ser el usuario del SO).
- Tener permisos para crear BD y escribir en la carpeta del proyecto.

### ¿Cómo abrir la consola?

- **macOS / Linux**
  Abre **Terminal**, navega a la carpeta del proyecto:

  ```bash
  cd /ruta/a/vuelos_min
  ```

  Para entrar a psql:

  ```bash
  psql
  ```

  (Si necesitas usuario/base específicos: `psql -U tu_usuario -d postgres`)

- **Windows (3 opciones)**

  1. **SQL Shell (psql)** (recomendado para principiantes)

     - Abre “SQL Shell (psql)” desde el menú Inicio.
     - Responde a las preguntas (host, database, user, port, password). Puedes dejar en blanco y presionar Enter si usas valores por defecto.
     - Dentro de `psql`, cambia el directorio de trabajo a la carpeta del proyecto con `\cd`:

       ```powershell
       \cd C:\ruta\al\proyecto\vuelos_min
       \pwd   -- para verificar la ruta
       ```

  2. **PowerShell**

     - Abre PowerShell.
     - Navega a tu carpeta:

       ```powershell
       cd C:\ruta\al\proyecto\vuelos_min
       ```

     - Entra a psql (si está en el PATH):

       ```powershell
       psql -U tu_usuario -d postgres
       ```

  3. **CMD (Símbolo del sistema)**
     Similar a PowerShell:

     ```powershell
     cd C:\ruta\al\proyecto\vuelos_min
     psql -U tu_usuario -d postgres
     ```

> Tip psql:
> `\q` salir, `\c base` conectar, `\dt` listar tablas, `\d tabla` ver definición, `\pwd` carpeta actual, `\cd RUTA` cambiar carpeta, `\i archivo.sql` ejecutar archivo.

## Paso 1: Crear la base y las tablas (01_schema.sql)

1. Abre **psql** y asegúrate de estar en la carpeta del proyecto (`\pwd` debe mostrar `.../vuelos_min`).
2. Ejecuta el script:

```sql
\i sql/01_schema.sql
```

Este archivo:

- Crea la base de datos `vuelos_min` (si ya existe, comenta esa línea).
- Se conecta a `vuelos_min`.
- Elimina las tablas si existen.
- Crea las tablas `airports`, `flights`, `passengers`, `bookings` e índices básicos.

**Verificaciones rápidas:**

```sql
\c vuelos_min
\dt
\d flights
```

## Paso 2: Cargar datos de ejemplo con SQL (02_impor.sql)

Ejecuta el script que **inserta datos** sin usar CSV:

```sql
\i sql/02_impor.sql
```

**Verificaciones rápidas:**

```sql
SELECT COUNT(*) FROM airports;
SELECT COUNT(*) FROM flights;
SELECT COUNT(*) FROM passengers;
SELECT COUNT(*) FROM bookings;
```

## (Opcional) Importar datos desde CSV con \copy

Si quieres practicar importación CSV (en lugar de los INSERT del paso 2), haz esto:

1. **Limpia las tablas** (en este orden por dependencias):

```sql
DELETE FROM bookings;
DELETE FROM flights;
DELETE FROM passengers;
DELETE FROM airports;
```

2. Asegúrate de que **psql** esté **posicionado en la carpeta del proyecto**:

   - macOS/Linux: ya estás en `vuelos_min` si abriste allí la Terminal.
   - Windows/SQL Shell:

     ```powershell
     \cd C:\ruta\al\proyecto\vuelos_min
     \pwd
     ```

3. Ejecuta las cargas (las rutas son relativas a la carpeta del proyecto):

```sql
\copy airports  (airport_code,name,city,country) FROM 'data/airports.csv'   WITH (FORMAT csv, HEADER true)
\copy flights   (flight_code,origin_airport,destination_airport,scheduled_departure,scheduled_arrival,status) FROM 'data/flights.csv' WITH (FORMAT csv, HEADER true)
\copy passengers(document_id,full_name,email)   FROM 'data/passengers.csv' WITH (FORMAT csv, HEADER true)
\copy bookings  (booking_id,flight_code,document_id,seat,booking_status,price_usd) FROM 'data/bookings.csv' WITH (FORMAT csv, HEADER true)
```

> Windows: si tienes errores de ruta, usa comillas dobles y ruta absoluta, por ejemplo:
> `\copy airports (...) FROM "C:/Users/TuUsuario/Desktop/vuelos_min/data/airports.csv" WITH (FORMAT csv, HEADER true)`

## Consultas (explicadas + ejecutables)

A continuación, **primero te explico** qué hace cada consulta y **luego** te doy el SQL para ejecutarla.

### 1) Ver todos los vuelos (SELECT básico)

**Qué hace:** lista los vuelos con su ruta y horarios.
**Por qué:** refuerza `SELECT ... FROM` y `ORDER BY`.

```sql
SELECT
  flight_code,
  origin_airport,
  destination_airport,
  scheduled_departure,
  scheduled_arrival,
  status
FROM flights
ORDER BY scheduled_departure;
```

### 2) Filtrar vuelos por estado (WHERE)

**Qué hace:** muestra solo vuelos “scheduled”.
**Por qué:** practicar `WHERE` con igualdad.

```sql
SELECT flight_code, status
FROM flights
WHERE status = 'scheduled'
ORDER BY flight_code;
```

### 3) Contar reservas confirmadas por vuelo (GROUP BY)

**Qué hace:** cuenta cuántas reservas confirmadas tiene cada vuelo.
**Por qué:** practicar `COUNT()` y `GROUP BY`.

```sql
SELECT
  flight_code,
  COUNT(*) AS confirmed_bookings
FROM bookings
WHERE booking_status = 'confirmed'
GROUP BY flight_code
ORDER BY confirmed_bookings DESC, flight_code;
```

### 4) JOIN simple: reservas con datos del vuelo

**Qué hace:** une `bookings` con `flights` para ver ruta y horario de cada reserva.
**Por qué:** introducir `JOIN` en una relación directa por `flight_code`.

```sql
SELECT
  b.booking_id,
  b.document_id,
  f.flight_code,
  f.origin_airport,
  f.destination_airport,
  f.scheduled_departure,
  b.booking_status
FROM bookings b
JOIN flights  f ON f.flight_code = b.flight_code
ORDER BY f.scheduled_departure, b.booking_id;
```

### 5) JOIN con alias duplicados: vuelos con nombres de aeropuertos

**Qué hace:** muestra cada vuelo con el **nombre** del aeropuerto de origen y destino (no solo el código).
**Por qué:** practicar dos JOINs a la **misma** tabla `airports` usando alias distintos.

```sql
SELECT
  f.flight_code,
  f.origin_airport,
  ao.name  AS origin_name,
  f.destination_airport,
  ad.name  AS destination_name,
  f.scheduled_departure,
  f.scheduled_arrival
FROM flights f
JOIN airports ao ON ao.airport_code = f.origin_airport
JOIN airports ad ON ad.airport_code = f.destination_airport
ORDER BY f.scheduled_departure;
```

### 6) Itinerario de un pasajero (JOIN + filtro)

**Qué hace:** lista todos los vuelos reservados por un pasajero específico.
**Por qué:** combinar `JOIN` y `WHERE` por una clave de negocio (`document_id`).

```sql
SELECT
  p.document_id,
  p.full_name,
  f.flight_code,
  f.origin_airport,
  f.destination_airport,
  f.scheduled_departure,
  f.scheduled_arrival,
  b.booking_status
FROM passengers p
JOIN bookings  b ON b.document_id = p.document_id
JOIN flights   f ON f.flight_code  = b.flight_code
WHERE p.document_id = 'CC-100'       -- cambia este valor para probar
ORDER BY f.scheduled_departure;
```

### 7) Rutas más demandadas (JOIN + GROUP BY)

**Qué hace:** cuenta reservas confirmadas por ruta (origen–destino) y ordena de mayor a menor.
**Por qué:** practicar `JOIN` + `GROUP BY` en más de una columna.

```sql
SELECT
  f.origin_airport,
  f.destination_airport,
  COUNT(b.booking_id) AS confirmed_bookings
FROM flights f
JOIN bookings b
  ON b.flight_code = f.flight_code
 AND b.booking_status = 'confirmed'
GROUP BY f.origin_airport, f.destination_airport
ORDER BY confirmed_bookings DESC, f.origin_airport, f.destination_airport;
```

## Exportar resultados a CSV (con \copy)

**Idea:** ejecutar una consulta y **exportar** el resultado a la carpeta `exports/`.

### Ejemplo: ocupación por vuelo

```sql
\copy (
  SELECT
    f.flight_code,
    COUNT(b.booking_id) AS confirmed_bookings
  FROM flights f
  LEFT JOIN bookings b
    ON b.flight_code = f.flight_code
   AND b.booking_status = 'confirmed'
  GROUP BY f.flight_code
  ORDER BY confirmed_bookings DESC, f.flight_code
) TO 'exports/ocupacion_por_vuelo.csv' WITH (FORMAT csv, HEADER true)
```

### Ejemplo: rutas top

```sql
\copy (
  SELECT
    f.origin_airport,
    f.destination_airport,
    COUNT(b.booking_id) AS confirmed_bookings
  FROM flights f
  JOIN bookings b
    ON b.flight_code = f.flight_code
   AND b.booking_status = 'confirmed'
  GROUP BY f.origin_airport, f.destination_airport
  ORDER BY confirmed_bookings DESC
) TO 'exports/rutas_top.csv' WITH (FORMAT csv, HEADER true)
```

**Windows (rutas):**

- Puedes usar **rutas relativas** como arriba si tu `\pwd` es `.../vuelos_min`.
- O rutas absolutas con comillas dobles:

  ```sql
  TO "C:/Users/TuUsuario/Desktop/vuelos_min/exports/rutas_top.csv"
  ```

> Si ves “permission denied” o “no such file or directory”:
>
> - Verifica que la carpeta `exports/` exista y que `\pwd` apunte al proyecto.
> - En Windows, prefiere rutas con `/` o escapa con `\\`.

## Mantenimiento y limpieza

### ¿Cómo borrar la base de datos?

1. No puedes borrar la BD si estás conectado a ella. Conéctate a `postgres` (o a otra):

```sql
\c postgres
```

2. Ahora sí:

```sql
DROP DATABASE vuelos_min;
```

### ¿Cómo borrar una tabla?

```sql
DROP TABLE bookings;        -- borra la tabla (debe estar vacía si otra tiene FK a ella)
DROP TABLE IF EXISTS X;     -- mismo, pero no falla si no existe
```

### ¿Cómo borrar una columna?

```sql
ALTER TABLE flights DROP COLUMN status;
```

> Ten cuidado: perderás ese dato para siempre.
> (Si solo quieres “ocultar” temporalmente, mejor no lo hagas en producción.)

### ¿Cómo borrar filas (datos) de una tabla?

- **Borrar todo el contenido** (rápido, sin condiciones):

  ```sql
  TRUNCATE TABLE bookings;
  ```

- **Borrar con condición** (ej.: reservas canceladas):

  ```sql
  DELETE FROM bookings
  WHERE booking_status = 'canceled';
  ```

- **Borrar por rango de fechas** (ej.: vuelos de diciembre 2025):

  ```sql
  DELETE FROM flights
  WHERE scheduled_departure >= '2025-12-01'
    AND scheduled_departure <  '2026-01-01';
  ```

### ¿Cómo actualizar datos?

```sql
UPDATE flights
SET status = 'canceled'
WHERE flight_code = 'LA211-2025-12-04T12:00';
```

## Mini-checklist para la clase

1. Ejecutar `\i sql/01_schema.sql`.
2. Ejecutar `\i sql/02_impor.sql` (o practicar `\copy` con CSV).
3. Verificar con `\dt` y `SELECT COUNT(*)`.
4. Probar consultas 1–7 en orden.
5. Exportar al menos un reporte a `exports/`.
6. Practicar `DELETE`, `TRUNCATE`, `ALTER TABLE DROP COLUMN` y (opcional) `DROP DATABASE`.

## Apéndice: comandos útiles de psql

- `\q` salir
- `\c nombre_bd` conectar a base
- `\dt` listar tablas
- `\d nombre_tabla` ver definición de tabla
- `\i ruta/al/archivo.sql` ejecutar un archivo
- `\pwd` ver carpeta actual
- `\cd RUTA` cambiar carpeta (útil para `\copy` con rutas relativas)
