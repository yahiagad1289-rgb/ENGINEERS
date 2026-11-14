-- Person 4: damage_reports and notifications
-- Run AFTER users, bikes and rentals exist (they are referenced by foreign keys).

CREATE TABLE damage_reports (
    damage_report_id SERIAL PRIMARY KEY,
    bike_id     INT NOT NULL
        REFERENCES bikes(bike_id) ON DELETE RESTRICT,     -- keep damage history: a bike with reports cannot be deleted
    reported_by INT NOT NULL
        REFERENCES users(user_id) ON DELETE RESTRICT,     -- keep who reported the damage
    rental_id   INT
        REFERENCES rentals(rental_id) ON DELETE SET NULL, -- report survives if the rental row is removed
    description TEXT NOT NULL,
    severity    VARCHAR(10) NOT NULL DEFAULT 'low'
        CHECK (severity IN ('low', 'medium', 'high')),
    status      VARCHAR(20) NOT NULL DEFAULT 'open'
        CHECK (status IN ('open', 'in_review', 'resolved')),
    reported_at TIMESTAMP NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMP
);

CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id   INT NOT NULL
        REFERENCES users(user_id) ON DELETE CASCADE,      -- notifications are meaningless without their user
    rental_id INT
        REFERENCES rentals(rental_id) ON DELETE SET NULL, -- keep the message if the rental row is removed
    type      VARCHAR(30) NOT NULL
        CHECK (type IN ('rental_started', 'rental_ended', 'payment', 'damage_update', 'system')),
    message   TEXT NOT NULL,
    is_read   BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
