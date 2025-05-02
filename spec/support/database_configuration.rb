# frozen_string_literal: true

# Rails.root is not available in this context, so we define a stub
unless defined?(Rails)
  module Rails
    def self.root
      Pathname.new(File.expand_path('../..', __FILE__))
    end

    def self.env
      'test'
    end
  end
end

require 'erb'

# Load database configuration from database.yml
def load_database_config
  config_file = Rails.root.join('config', 'database.yml')
  raw_config = File.read(config_file)
  YAML.safe_load(ERB.new(raw_config).result, aliases: true)[Rails.env]
end

def docker_postgres_config
  {
    'host' => ENV['DB_HOST'] || 'localhost',
    'port' => ENV['DB_PORT'] || 5432,
    'database' => ENV['DB_NAME'] || 'elev8_test',
    'username' => ENV['DB_USER'] || 'postgres',
    'password' => ENV['DB_PASS'] || '',
    'encoding' => 'unicode'
  }
end

def running_in_ci?
  ENV['CI'] == 'true'
end

def running_in_docker?
  File.exist?('/.dockerenv')
end

def choose_database_config
  if running_in_ci? || running_in_docker?
    puts "Using Docker/CI PostgreSQL configuration"
    docker_postgres_config
  else
    puts "Using default database.yml configuration"
    load_database_config
  end
end

# Apply the chosen configuration
ActiveRecord::Base.establish_connection(choose_database_config)

puts "ActiveRecord connection configuration: #{ActiveRecord::Base.connection_config}"
