CREATE EXTENSION IF NOT EXISTS pg_duckdb;


CREATE TABLE IF NOT EXISTS demo_analytics_events_pg (
    id SERIAL,
    event_type VARCHAR,
    user_id INT,
    event_time TIMESTAMP
);
