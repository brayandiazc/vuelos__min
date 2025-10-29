-- ============================================
-- 02_impor.sql
-- Generar datos de ejemplo usando SQL (sin CSV).
-- Ejecutar después de 01_schema.sql
-- ============================================
-- (Opcional) Asegúrate de estar en la BD correcta:
-- \c vuelos_min
-- 1) Limpiar datos en orden (por dependencias)
DELETE FROM bookings;
DELETE FROM flights;
DELETE FROM passengers;
DELETE FROM airports;
-- 2) Datos base: Aeropuertos (IATA de 3 letras)
INSERT INTO airports (airport_code, name, city, country)
VALUES ('BOG', 'El Dorado', 'Bogotá', 'Colombia'),
  ('MDE', 'José María Córdova', 'Rionegro', 'Colombia'),
  ('SCL', 'Arturo Merino Benítez', 'Santiago', 'Chile'),
  ('LIM', 'Jorge Chávez', 'Lima', 'Perú'),
  (
    'MEX',
    'Benito Juárez',
    'Ciudad de México',
    'México'
  );
-- 3) Datos base: Pasajeros
INSERT INTO passengers (document_id, full_name, email)
VALUES ('CC-100', 'Ana Pérez', 'ana@example.com'),
  ('CC-101', 'Bruno Díaz', 'bruno@example.com'),
  ('CC-102', 'Camila Soto', 'camila@example.com'),
  ('CC-103', 'Diego Ramírez', 'diego@example.com'),
  ('CC-104', 'Elena Torres', 'elena@example.com'),
  ('CC-105', 'Fabio Gómez', 'fabio@example.com'),
  (
    'CC-106',
    'Gabriela Naranjo',
    'gabriela@example.com'
  ),
  ('CC-107', 'Héctor Luna', 'hector@example.com'),
  ('CC-108', 'Isabel Vera', 'isabel@example.com'),
  ('CC-109', 'Julián Ríos', 'julian@example.com');
-- 4) Vuelos (rutas y horarios simples)
-- Formato de flight_code: <ALIAS>-<YYYY-MM-DD>T<HH:MM>
-- Ej: LA100-2025-12-01T08:30
INSERT INTO flights (
    flight_code,
    origin_airport,
    destination_airport,
    scheduled_departure,
    scheduled_arrival,
    status
  )
VALUES (
    'LA100-2025-12-01T08:30',
    'BOG',
    'MDE',
    '2025-12-01 08:30:00',
    '2025-12-01 09:30:00',
    'scheduled'
  ),
  (
    'LA101-2025-12-01T18:00',
    'MDE',
    'BOG',
    '2025-12-01 18:00:00',
    '2025-12-01 19:00:00',
    'scheduled'
  ),
  (
    'LA200-2025-12-01T10:00',
    'BOG',
    'SCL',
    '2025-12-01 10:00:00',
    '2025-12-01 15:00:00',
    'scheduled'
  ),
  (
    'LA201-2025-12-02T11:00',
    'SCL',
    'BOG',
    '2025-12-02 11:00:00',
    '2025-12-02 16:00:00',
    'scheduled'
  ),
  (
    'LA300-2025-12-02T09:15',
    'BOG',
    'LIM',
    '2025-12-02 09:15:00',
    '2025-12-02 12:15:00',
    'delayed'
  ),
  (
    'LA301-2025-12-02T14:00',
    'LIM',
    'BOG',
    '2025-12-02 14:00:00',
    '2025-12-02 17:00:00',
    'scheduled'
  ),
  (
    'LA400-2025-12-03T07:45',
    'BOG',
    'MEX',
    '2025-12-03 07:45:00',
    '2025-12-03 12:15:00',
    'scheduled'
  ),
  (
    'LA401-2025-12-03T13:30',
    'MEX',
    'BOG',
    '2025-12-03 13:30:00',
    '2025-12-03 18:00:00',
    'canceled'
  );
-- 5) Reservas (algunas confirmadas y otras canceladas)
INSERT INTO bookings (
    booking_id,
    flight_code,
    document_id,
    seat,
    booking_status,
    price_usd
  )
VALUES (
    'BKG-001',
    'LA100-2025-12-01T08:30',
    'CC-100',
    '12A',
    'confirmed',
    120.00
  ),
  (
    'BKG-002',
    'LA100-2025-12-01T08:30',
    'CC-101',
    '12B',
    'confirmed',
    120.00
  ),
  (
    'BKG-003',
    'LA100-2025-12-01T08:30',
    'CC-102',
    '14C',
    'canceled',
    0.00
  ),
  (
    'BKG-004',
    'LA101-2025-12-01T18:00',
    'CC-100',
    '10A',
    'confirmed',
    110.00
  ),
  (
    'BKG-005',
    'LA101-2025-12-01T18:00',
    'CC-103',
    '10B',
    'confirmed',
    110.00
  ),
  (
    'BKG-006',
    'LA200-2025-12-01T10:00',
    'CC-104',
    '03C',
    'confirmed',
    450.00
  ),
  (
    'BKG-007',
    'LA200-2025-12-01T10:00',
    'CC-105',
    '06D',
    'confirmed',
    430.00
  ),
  (
    'BKG-008',
    'LA200-2025-12-01T10:00',
    'CC-106',
    '08A',
    'canceled',
    0.00
  ),
  (
    'BKG-009',
    'LA201-2025-12-02T11:00',
    'CC-104',
    '02A',
    'confirmed',
    440.00
  ),
  (
    'BKG-010',
    'LA201-2025-12-02T11:00',
    'CC-107',
    '02B',
    'confirmed',
    440.00
  ),
  (
    'BKG-011',
    'LA300-2025-12-02T09:15',
    'CC-108',
    '15A',
    'confirmed',
    220.00
  ),
  (
    'BKG-012',
    'LA300-2025-12-02T09:15',
    'CC-109',
    '15B',
    'confirmed',
    220.00
  ),
  (
    'BKG-013',
    'LA301-2025-12-02T14:00',
    'CC-108',
    '09C',
    'confirmed',
    210.00
  ),
  (
    'BKG-014',
    'LA301-2025-12-02T14:00',
    'CC-102',
    '09D',
    'canceled',
    0.00
  ),
  (
    'BKG-015',
    'LA400-2025-12-03T07:45',
    'CC-101',
    '04A',
    'confirmed',
    550.00
  ),
  (
    'BKG-016',
    'LA400-2025-12-03T07:45',
    'CC-106',
    '04B',
    'confirmed',
    540.00
  ),
  (
    'BKG-017',
    'LA401-2025-12-03T13:30',
    'CC-100',
    '20C',
    'canceled',
    0.00
  ),
  (
    'BKG-018',
    'LA401-2025-12-03T13:30',
    'CC-105',
    '20D',
    'canceled',
    0.00
  );
-- Fin de 02_impor.sql