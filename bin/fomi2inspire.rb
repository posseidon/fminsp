#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'yaml'

$LOAD_PATH << './lib/'
require 'fomi2inspire.rb'


program :version, Fomi2inspire::VERSION
program :description, 'Transforming FOMI data to INSPIRE'

command :download do |c|
  c.syntax = 'fomi2inspire download [options]'
  c.summary = 'Downloading Software installers/executables from data/config/software.yml'
  c.description = 'Downloading Software installers/executables from data/config/software.yml'
  c.example 'description', 'command example'
  c.option '-dest', 'Destination of downloaded files'
  c.action do |args, options|
    Fomi2inspire.download(args[0])
  end
end

command :drop do |c|
  c.syntax = 'fomi2inspire delete [options]'
  c.summary = 'Drops role or database'
  c.description = 'Drops database role or databases from data/setup/create_user_db.yml'
  c.example 'description', 'command example'
  c.option '-user', 'Role'
  c.option '-db', 'Database'
  c.action do |args, options|
    config = {}
    config[:host] = ask("Hostname:")
    # Request for DB admin username and password
    config[:user] = ask("DB Admin username:")
    config[:password] = ask("DB Admin user password:"){ |q|
      q.echo = "*"
    }
    options.user.nil? ? config[:dbname] = args[0] : config[:usr] = args[0]
    Fomi2inspire.drop(config)
  end  
end

command :setup do |c|
  c.syntax = 'fomi2inspire setup [options]'
  c.summary = 'Setup FOMI and/or INSPIRE database with user creation.'
  c.description = 'Create user, grant wrights on database.'
  c.example 'description', 'command example'
  c.option '-user', 'Setup new Role'
  c.option '-db', 'Setup new DB'

  # Parse options and run command
  c.action do |args, options|
    config = {}
    config[:host] = ask("Hostname:")
    # Request for DB admin username and password
    config[:user] = ask("DB Admin username:")
    config[:password] = ask("DB Admin user password:"){ |q|
      q.echo = "*"
    }

    # Setup User/Role
    if options.user
      # -user args[0]
      config[:usr] = args[0]

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

      # Setup User
      Fomi2inspire.setup_user(config)
    else
      # Owner
      config[:usr] = ask("Owner role name:")
      # Which database to setup?
      config[:dbname] = ask("New Database name:")
      # Request for postgis_template template name
      config[:template] = ask("PostGIS template name for new database: #{config[:dbname]}")
      puts "Setting up #{config[:dbname]} ...".foreground(:green)

      # Setup Database
      Fomi2inspire::setup_db(config)
    end
  end
end

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
    #schema_definition_file = ask("Schema Definition File:")
    schema_definition_file = "./data/config/feature_types.txt"
    Fomi2inspire::check_schema_validity?(config, schema_definition_file)
  end
end

command :transform do |c|
  c.syntax = 'fomi2inspire transform [options]'
  c.summary = 'Transforming FOMI specific data into Inspire compatible.'
  c.description = 'Transforming FOMI specific data into Inspire compatible.'
  c.example 'description', '-conn database.yml -schema [Au|Cad|Gn]'
  c.option '-conn', 'Connection configuration YML file for both source and destination databases.'
  c.option '-schema', 'Specify Inspire Schema'
  c.action do |args, options|
    config = {}
    config[:conf] = args[0]
    config[:schema] = args[1]
    Fomi2inspire.transform_data(config)
  end
end

command :update do |c|
  c.syntax = 'fomi2inspire update [options]'
  c.summary = 'Update specified record from FOMI schema into INSPIRE schema'
  c.description = 'Update specified record from FOMI schema into INSPIRE schema'
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Fomi2inspire::Commands::Update
  end
end

