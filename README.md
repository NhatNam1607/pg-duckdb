# Deploy pg_duckdb (PostgreSQL + DuckDB)

This repository contains a standard setup to deploy **pg_duckdb**—transforming any Docker-compatible server into a **miniature MotherDuck**. It leverages PostgreSQL for connection management and DuckDB for blazing-fast analytical processing.

## File Structure
- `Dockerfile`: Pulls the official, highly optimized build from CrunchyData/MotherDuck.
- `init.sql`: Contains the `CREATE EXTENSION pg_duckdb;` command, which runs automatically upon initial startup to enable the DuckDB engine without manual intervention.

## ☁️ Deployment Guide

You can deploy this on any platform that supports Docker (e.g., a self-hosted VPS, AWS, GCP, Render, Railway, Dokploy, etc.).

1. **Deploying the Docker Container**:
   Build and run the Docker image from this repository. 

2. **🚨 CRITICAL STEP 1: Environment Variables**:
   You must provide the following environment variables for PostgreSQL to start securely:
   - `POSTGRES_USER`: Your admin username (e.g., `admin`)
   - `POSTGRES_PASSWORD`: Your secure password (e.g., `super_secret_password`)
   - `POSTGRES_DB`: The default database name (e.g., `postgres`)

3. **🚨 CRITICAL STEP 2: Persistent Volume (STORAGE)**:
   To prevent data loss when the container restarts, you **must mount a persistent volume** to the following path:
   - **Container Path**: `/var/lib/postgresql/data`

## 🔌 Connecting with DBeaver / DataGrip
Once deployed and the port (default `5432`) is exposed, connect to it using any standard PostgreSQL client (like DBeaver, DataGrip, or pgAdmin) using the host IP/Domain and the credentials you configured.

Open a SQL Editor and try querying a remote Parquet file directly using DuckDB's engine right inside PostgreSQL:
```sql
-- Test querying a remote file directly using the power of DuckDB
SELECT * FROM duckdb_read_parquet('https://shell.duckdb.org/data/tpch/0_01/parquet/lineitem.parquet') LIMIT 10;
```
