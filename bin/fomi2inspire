#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'yaml'

$LOAD_PATH << './lib/'
require 'fomi2inspire.rb'


program :version, Fomi2inspire::VERSION
program :description, 'Transforming FOMI data to INSPIRE'
 
command :check do |c|
  c.syntax = 'fomi2inspire check -config or -host hostname -db inspire_db_name'
  c.summary = 'Checks if connection to inspire database. Also checks the existance of feature_types and gml_objects tables.'
  c.description = 'Usage: fomi2inspire check [-config database.yml] or -host hostname -dbname dbname'
  c.example 'description', ''
  c.option '-config', 'Connection with database.yml file'

  # Parse options and run command
  c.action do |args, options|
    config = {}
    unless options.config.nil?
      config = YAML.load_file(args[0])
      config[:password] = ask("Login Password"){|q|
        q.echo = "*"
      }
    else
      config[:adapter] = 'postgresql'
      config[:host] = ask("Hostname:")
      config[:database] = ask("Inspire Database name:")
      config[:username] = ask("Database user name:")
      config[:password] = ask("Database password:"){ |q|
        q.echo = "*"
      }
    end
    schema_definition_file = ask("Schema Definition File:")
    Fomi2inspire::check_schema_validity?(config, schema_definition_file)
  end
end

command :setup do |c|
  c.syntax = 'fomi2inspire setup [options]'
  c.summary = 'Setup FOMI and/or INSPIRE database with user creation.'
  c.description = 'Create user, grant wrights on database.'
  c.example 'description', 'command example'

  # Parse options and run command
  c.action do |args, options|
    config = {}
    config[:host] = ask("Hostname:")
    # Which database to setup?
    config[:dbname] = ask("New Database name:")
    puts "Setting up #{config[:dbname]} ...".foreground(:green)

    # Request for DB admin username and password
    config[:user] = ask("DB Admin username:")
    config[:password] = ask("DB Admin user password:"){ |q|
      q.echo = "*"
    }

    # Request for New role name and password
    config[:usr] = ask("New role name:")
    password_match = true
    begin
      puts "Password does not match !".foreground(:red) if password_match == false
      first_pwd = ask("New role's password:"){|q|
        q.echo = "*"
      }
      second_pwd = ask("Repeat new role's password:"){|q|
        q.echo = "*"
      }
      password_match = first_pwd.eql?(second_pwd)
    end while !password_match
    config[:pwd] = second_pwd

    # Request for postgis_template template name
    config[:template] = ask("PostGIS template name for new database: #{config[:dbname]}")

    Fomi2inspire::setup_db(config)
  end
end


command :transform do |c|
  c.syntax = 'fomi2inspire transform [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.option '--inspire_schema', 'Specify Inspire Schema for Tranformation'
  c.option '--inspire_transformation_config', 'Configuration for mapping data attributes'
  c.action do |args, options|
    # Do something or c.when_called Fomi2inspire::Commands::Transform
  end
end

command :update do |c|
  c.syntax = 'fomi2inspire update [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Fomi2inspire::Commands::Update
  end
end

