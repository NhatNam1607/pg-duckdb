# Use the official image
FROM pgduckdb/pgduckdb:latest

# 1. Switch to root user to install dependencies and generate SSL certificates
USER root

# Install OpenSSL (skip recommended packages to keep the image lightweight)
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssl && \
    rm -rf /var/lib/apt/lists/*

# 2. Create a directory to store the certificates inside the container
RUN mkdir -p /etc/ssl/postgresql

# 3. Use OpenSSL to automatically generate a self-signed certificate
# Validity is set to 10 years (3650 days). 
# We only need this to encrypt the traffic, so a self-signed cert is perfect.
RUN openssl req -new -x509 -days 3650 -nodes -text -out /etc/ssl/postgresql/server.crt \
    -keyout /etc/ssl/postgresql/server.key \
    -subj "/C=VN/ST=HCM/L=HCM/O=MyAnalytics/CN=duckdb.local"

# 4. Postgres STRICTLY requires the server.key to be owned by the internal [postgres] user 
# and have restricted 0600 permissions.
RUN chown postgres:postgres /etc/ssl/postgresql/server.key /etc/ssl/postgresql/server.crt && \
    chmod 0600 /etc/ssl/postgresql/server.key /etc/ssl/postgresql/server.crt

# Disable telemetry data collection for privacy
ENV DUCKDB_NO_TELEMETRY=1

# Copy SQL initialization script
COPY init.sql /docker-entrypoint-initdb.d/

# Switch back to the default postgres user for security
USER postgres

EXPOSE 5432

# 5. Override the default Postgres startup command (CMD)
# Force the server to load the generated certificates and ENABLE SSL mode
CMD ["postgres", "-c", "ssl=on", "-c", "ssl_cert_file=/etc/ssl/postgresql/server.crt", "-c", "ssl_key_file=/etc/ssl/postgresql/server.key"]
