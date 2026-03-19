# Postgresl image has duckdb extension
FROM pgduckdb/pgduckdb:16-v1.1.1

ENV DUCKDB_NO_TELEMETRY=1

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
