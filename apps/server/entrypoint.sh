#!/bin/sh
set -e

echo "Waiting for database to accept connections..."
MAX_RETRIES=15
COUNT=0

until pnpm db:migrate:deploy || [ $COUNT -eq $MAX_RETRIES ]; do
  echo "Database not ready yet or migration failed, retrying in 2 seconds... ($COUNT/$MAX_RETRIES)"
  sleep 2
  COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
  echo "Failed to run migrations after $MAX_RETRIES retries, continuing startup..."
fi

echo "Starting NestJS server..."
if [ -f "dist/src/main.js" ]; then
  exec node dist/src/main.js
else
  exec node dist/main.js
fi

