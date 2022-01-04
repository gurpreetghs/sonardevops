#!/bin/bash

connection_string="postgres://$DATABASE_CONNECTION_USERNAME:$DATABASE_CONNECTION_PASSWORD@$DATABASE_CONNECTION_HOST:5432/postgres"

connections=$(psql ${connection_string} -t -c "select count(*) from pg_stat_activity where datname = '${DATABASE_CONNECTION_DATABASE}';")

if [ "$connections" -gt "0" ]; then
   echo "There are currently active connections. Please close them and try again.";
   exit 1;
fi

pg_dump --no-password --verbose --format=p --no-owner --create --clean --no-privileges --no-tablespaces --no-unlogged-table-data --inserts ${REMOTE_DATABASE_CONNECTION_STRING} | psql -v ON_ERROR_STOP=1 -a ${connection_string}