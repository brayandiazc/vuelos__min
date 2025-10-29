-- ============================================
-- 01_schema.sql
-- Crea la base de datos (opcional), se conecta,
-- elimina tablas si existen y vuelve a crearlas.
-- Pensado para ejecutarse con psql.
-- ============================================
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS passengers;
DROP TABLE IF EXISTS airports;
-- 3) Crear tablas (modelo mínimo y claro).
-- Aeropuertos
CREATE TABLE airports (
  airport_code CHAR(3) PRIMARY KEY,
  -- IATA de 3 letras (ej: BOG)
  name TEXT NOT NULL,
  city TEXT,
  country TEXT
);
-- Vuelos
CREATE TABLE flights (
  flight_code TEXT PRIMARY KEY,
  -- ej: LA1234-2025-12-01T08:30
  origin_airport CHAR(3) NOT NULL REFERENCES airports(airport_code),
  destination_airport CHAR(3) NOT NULL REFERENCES airports(airport_code),
  scheduled_departure TIMESTAMP NOT NULL,
  -- 'YYYY-MM-DD HH:MI:SS'
  scheduled_arrival TIMESTAMP NOT NULL,
  status TEXT NOT NULL -- scheduled, delayed, canceled, completed
);
-- Pasajeros
CREATE TABLE passengers (
  document_id TEXT PRIMARY KEY,
  -- cédula/pasaporte
  full_name TEXT NOT NULL,
  email TEXT UNIQUE
);
-- Reservas
CREATE TABLE bookings (
  booking_id TEXT PRIMARY KEY,
  -- identificador de la reserva
  flight_code TEXT NOT NULL REFERENCES flights(flight_code),
  document_id TEXT NOT NULL REFERENCES passengers(document_id),
  seat TEXT,
  -- ej: '12A'
  booking_status TEXT NOT NULL,
  -- confirmed, canceled
  price_usd NUMERIC(10, 2) -- precio simple
);
-- 4) Índices útiles (simples).
CREATE INDEX idx_flights_route ON flights(origin_airport, destination_airport);
CREATE INDEX idx_bookings_flight ON bookings(flight_code);
CREATE INDEX idx_bookings_passenger ON bookings(document_id);
-- Fin de 01_schema.sql