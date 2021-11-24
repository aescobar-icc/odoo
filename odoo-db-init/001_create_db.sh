#!/bin/bash
set -e
echo "Running Init oddo db"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $PGUSER;
    ALTER USER $PGUSER with encrypted password '$PGPASSWORD';
    ALTER USER $PGUSER CREATEDB;
    ALTER USER admin with encrypted password '$PGPASSWORD';
    ALTER USER admin CREATEDB;
    CREATE DATABASE $PGDB;
    GRANT ALL PRIVILEGES ON DATABASE $PGDB TO $PGUSER;
    GRANT ALL PRIVILEGES ON DATABASE postgres TO $PGUSER;
EOSQL