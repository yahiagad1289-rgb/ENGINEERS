-- Smart Bike Rental - Milestone 2
-- Person 2: Bikes & Docking Stations
-- Note: docking_stations must be created before bikes (foreign key dependency).

CREATE TABLE docking_stations (
    station_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    station_name   VARCHAR(100) NOT NULL,
    address        VARCHAR(255) NOT NULL,
    latitude       NUMERIC(9,6),
    longitude      NUMERIC(9,6),
    total_docks    INT NOT NULL CHECK (total_docks > 0),
    status         VARCHAR(20) NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active', 'inactive', 'maintenance')),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE bikes (
    bike_id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bike_code          VARCHAR(30) UNIQUE NOT NULL,
    bike_type          VARCHAR(20) NOT NULL DEFAULT 'standard'
                       CHECK (bike_type IN ('standard', 'electric')),
    status             VARCHAR(20) NOT NULL DEFAULT 'available'
                       CHECK (status IN ('available', 'rented', 'maintenance', 'damaged')),
    current_station_id BIGINT REFERENCES docking_stations(station_id),
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
