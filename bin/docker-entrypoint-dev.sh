#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
until pg_isready -h db -p 5432; do
  echo "Waiting for database to be ready..."
  sleep 2
done

# If database exists, migrate. Otherwise, setup (create and migrate)
bundle exec rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
