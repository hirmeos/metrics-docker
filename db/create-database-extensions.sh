#!/bin/bash

# modified from source: https://github.com/mrts/docker-postgresql-multiple-databases

set -e

echo "  Creating extension 'hstore'"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "hirmeos_wp6" <<-EOSQL
    create extension hstore;
EOSQL
