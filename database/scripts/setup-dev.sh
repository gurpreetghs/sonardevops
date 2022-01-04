#!/bin/bash

export DATABASE_CONNECTION_TYPE=postgres
export DATABASE_CONNECTION_HOST=postgres
export DATABASE_CONNECTION_PORT=5432
export DATABASE_CONNECTION_USERNAME=user
export DATABASE_CONNECTION_PASSWORD=pass
export DATABASE_CONNECTION_DATABASE=signatry_dev
export DATABASE_CONNECTION_STRING=postgres://user:pass@localhost:5432/signatry_dev
export DATABASE_QUERY_LOGGING=false
export REMOTE_DATABASE_CONNECTION_STRING=postgres://postgres:d8FLM4dfPsw6M5h5@35.226.205.3:5432/signatry_dev

pg_dump \
  --no-password \
  --verbose \
  --format=p \
  --no-owner \
  --create \
  --clean \
  --no-privileges \
  --no-tablespaces \
  --no-unlogged-table-data \
  --inserts \
  "${REMOTE_DATABASE_CONNECTION_STRING}" > /tmp/database.psql

psql \
  -v ON_ERROR_STOP=1 \
  --username "$POSTGRES_USER" \
  --dbname "$POSTGRES_DB" \
  < /tmp/database.psql
