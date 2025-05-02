# Elev8

## Disclaimer
This isn't production ready, only the development environment was considered

## Getting Started

### Prerequisites

- Docker  
- Docker Compose

### Running the App
Although not necessary, I recommend running the app inside a container

## Environment Variables
```
    # the app expects these environment variables to be present
    RAILS_ENV=development

    # replace `db` with `localhost` if you aren't running the app in container
    DATABASE_URL=postgres://postgres:password@db:5432/elev8_development

    JWT_SECRET_KEY=

    # integrations

    ELEVATEAPP_SERVICE_URL=
    ELEVATEAPP_SERVICE_TOKEN=
```

1. Build the containers:

   ```
   docker-compose build
   ```

2. The database runs inside docker ontainer, leave it in the background

    ```
    docker-compose up -d db
    ```

3. Start the app:

   ```
   docker-compose up web
   ```

4. Access the app:

   - API available at: http://localhost:3000  
   - PostgreSQL runs on port 5432

## Running Tests

1. Run specs:

   ```
   docker-compose run --rm test
   ```

## Dependencies

- Ruby 3.3.5
- Rails 8.0.2
- PostgreSQL 15

