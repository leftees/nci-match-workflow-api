require 'pathname'

class ConfigLoader
  attr_reader :config, :redacted_config

  def initialize(configPath, environment)
    @config = {}
    @redacted_config = {}

    environment = ENV['SCANNER_ENV'] if !environment.nil? && !ENV['SCANNER_ENV'].nil?
    environment = 'development' if environment.nil?

    scanner_config = load_yml_file(configPath, environment)

    @config['log_level'] = Logger.const_get(scanner_config['log_level']) rescue Logger::DEBUG
    @config['log_filepath'] = Logger.const_get(scanner_config['log_filepath']) rescue 'log/patient_rejoin_matchbox_scanner.log'

    @redacted_config['log_level'] = @config['log_level']
    @redacted_config['log_filepath'] = @config['log_filepath']

    load_database_config(scanner_config, environment)
    load_match_api_config(scanner_config, environment)
    load_ecog_api_config(scanner_config, environment)
  end

  def load_database_config(scanner_config, environment)
    if scanner_config.has_key?('database_config_path')
      database_config = load_yml_file(scanner_config['database_config_path'], environment)
      credentials = load_auth_credentials(database_config)
      store_config('database', load_db_config(database_config), credentials)
    else
      @config['database'] = nil
      @redacted_config['database'] = nil
    end
  end

  def load_match_api_config(scanner_config, environment)
    if scanner_config.has_key?('match_api_config_path')
      match_api_config = load_yml_file(scanner_config['match_api_config_path'], environment)
      credentials = load_auth_credentials(match_api_config)
      store_config('match_api', load_api_config(match_api_config), credentials)
    else
      @config['match_api'] = nil
      @redacted_config['match_api'] = nil
    end
  end

  def load_ecog_api_config(scanner_config, environment)
    if scanner_config.has_key?('ecog_api_config_path')
      ecog_api_config = load_yml_file(scanner_config['ecog_api_config_path'], environment)
      credentials = load_auth_credentials(ecog_api_config)
      store_config('ecog_api', load_api_config(ecog_api_config), credentials)
    else
      @config['ecog_api'] = nil
      @redacted_config['ecog_api'] = nil
    end
  end

  def load_yml_file(ymlPath, environment)
    Pathname.new(ymlPath).relative? ?
        YAML.load_file(File.join(File.dirname(__FILE__), ymlPath))[environment] :
        YAML.load_file(ymlPath)[environment]
  end

  def load_auth_credentials(config)
    username = config['clients']['default']['options']['user'] rescue nil
    password = config['clients']['default']['options']['password'] rescue nil
    return username, password
  end

  def load_db_config(config)
    return {
        'hosts' => config['clients']['default']['hosts'],
        'dbname' => config['clients']['default']['database']
    }
  end

  def load_api_config(config)
    return {
        'scheme' => config['clients']['default']['scheme'],
        'hosts' => config['clients']['default']['hosts'],
        'context' => config['clients']['default']['context']
    }
  end

  def store_config(key, yml_config, credentials)
    @config[key] = yml_config
    @config[key]['username'] = credentials[0]
    @config[key]['password'] = credentials[1]

    @redacted_config[key] = @config[key].clone
    @redacted_config[key]['username'] = '********'
    @redacted_config[key]['password'] = '********'
  end

  private :load_database_config, :load_match_api_config, :load_ecog_api_config, :load_yml_file, :load_auth_credentials, :load_api_config

end