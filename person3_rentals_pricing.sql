-- =====================================================================
-- Bike Sharing System - Person 3: Rentals & Pricing
-- Tables: pricing_plans, rentals
-- Target: MySQL 8.0.16+
-- Depends on: users (Person 1), bikes and docking_stations (Person 2).
-- Run those parts of 01_create_tables.sql BEFORE this section.
-- =====================================================================

-- =====================================================================
-- PERSON 3 - Pricing Plans & Rentals
-- =====================================================================

CREATE TABLE pricing_plans (
    plan_id          INT AUTO_INCREMENT PRIMARY KEY,
    plan_name        VARCHAR(50)   NOT NULL UNIQUE,
    unlock_fee       DECIMAL(8,2)  NOT NULL DEFAULT 0.00,
    price_per_minute DECIMAL(8,2)  NOT NULL,
    daily_cap        DECIMAL(8,2)  NULL,              -- NULL = no cap
    is_active        BOOLEAN       NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_plan_unlock CHECK (unlock_fee >= 0),
    CONSTRAINT chk_plan_price  CHECK (price_per_minute >= 0),
    CONSTRAINT chk_plan_cap    CHECK (daily_cap IS NULL OR daily_cap > 0)
);

CREATE TABLE rentals (
    rental_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id           INT           NOT NULL,
    bike_id           INT           NOT NULL,
    plan_id           INT           NOT NULL,
    start_station_id  INT           NOT NULL,
    end_station_id    INT           NULL,             -- NULL until the bike is returned
    start_time        DATETIME      NOT NULL,
    end_time          DATETIME      NULL,
    total_cost        DECIMAL(8,2)  NULL,             -- calculated when the rental ends
    status            VARCHAR(10)   NOT NULL DEFAULT 'active',
    CONSTRAINT fk_rental_user    FOREIGN KEY (user_id)          REFERENCES users(user_id),
    CONSTRAINT fk_rental_bike    FOREIGN KEY (bike_id)          REFERENCES bikes(bike_id),
    CONSTRAINT fk_rental_plan    FOREIGN KEY (plan_id)          REFERENCES pricing_plans(plan_id),
    CONSTRAINT fk_rental_start   FOREIGN KEY (start_station_id) REFERENCES docking_stations(station_id),
    CONSTRAINT fk_rental_end     FOREIGN KEY (end_station_id)   REFERENCES docking_stations(station_id),
    CONSTRAINT chk_rental_status CHECK (status IN ('active', 'completed', 'cancelled')),
    CONSTRAINT chk_rental_time   CHECK (end_time IS NULL OR end_time > start_time),
    CONSTRAINT chk_rental_cost   CHECK (total_cost IS NULL OR total_cost >= 0)
);
