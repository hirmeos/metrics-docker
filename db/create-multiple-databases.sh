#!/bin/bash

# modified from source: https://github.com/mrts/docker-postgresql-multiple-databases

set -e

function create_user_and_database() {
    local database=$1
    echo "  Creating database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE DATABASE $database;
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
    echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
    for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
        create_user_and_database $db;
        if [ -d /docker-entrypoint-initdb.d/$db ]; then
            for sqlf in /docker-entrypoint-initdb.d/$db/*; do 
                echo "    Adding file $sqlf to $db"
                psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" $db < $sqlf
            done
        else
        	echo "    No SQL files found for database $db"
        fi
    done
    echo "Multiple databases created"
fi
