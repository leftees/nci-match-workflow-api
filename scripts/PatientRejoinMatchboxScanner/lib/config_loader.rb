class ConfigLoader
  attr_reader :config

  def initialize(configPath, environment)
    @config = {}

    environment = 'development' if environment.nil?
    scanner_config = YAML.load_file(File.join(File.dirname(__FILE__), configPath))[environment]

    load_database_config(scanner_config)
    load_match_api_config(scanner_config)
    load_ecog_api_config(scanner_config)
  end

  def load_database_config(scanner_config)
    if scanner_config.has_key?('database_config_path')
      database_config = YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['database_config_path']))
      @config['database'] = {
          'hosts' => database_config['clients']['default']['hosts'],
          'dbname' => database_config['clients']['default']['database'],
          'username' =>database_config['clients']['default']['options']['user'],
          'password' => database_config['clients']['default']['options']['password'],
      }
    else
      @config['database'] = nil
    end
  end

  def load_match_api_config(scanner_config)
    if scanner_config.has_key?('match_api_config_path')
      match_api_config = YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['match_api_config_path']))
      @config['match_api'] = {
          'scheme' => match_api_config['default']['scheme'],
          'hostname' => match_api_config['default']['hostname'],
          'port' => match_api_config['default']['port'],
          'context' => match_api_config['default']['context'],
      }
    else
      @config['match_api'] = nil
    end
  end

  def load_ecog_api_config(scanner_config)
    if scanner_config.has_key?('ecog_api_config_path')
      ecog_api_config = YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['ecog_api_config_path']))
      @config['ecog_api'] = {
          'scheme' => ecog_api_config['default']['scheme'],
          'hostname' => ecog_api_config['default']['hostname'],
          'port' => ecog_api_config['default']['port'],
          'context' => ecog_api_config['default']['context'],
      }
    else
      @config['ecog_api'] = nil
    end
  end

  private :load_database_config, :load_match_api_config, :load_ecog_api_config

end