# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim

# Set working directory
WORKDIR /app

# Install dependencies required for development
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips \
    libjemalloc2 \
    nodejs \
    npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configure bundler for development
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Create necessary directories that will be mounted
RUN mkdir -p /app/tmp /app/log /app/storage /app/db

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Create a non-root user to run the application
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /app /usr/local/bundle

# Set the user for subsequent commands
USER rails

# Add a script to be used as an entrypoint
COPY --chown=rails:rails ./bin/docker-entrypoint-dev.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint-dev.sh

# Expose port 3000
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["/usr/bin/docker-entrypoint-dev.sh"]

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
