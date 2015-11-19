class ConfigLoader
  attr_reader :config

  def initialize(configPath, environment)
    @config = {}

    environment = ENV['SCANNER_ENV'] if !environment.nil? && !ENV['SCANNER_ENV'].nil?
    environment = 'development' if environment.nil?

    scanner_config = YAML.load_file(File.join(File.dirname(__FILE__), configPath))[environment]

    load_database_config(scanner_config, environment)
    load_match_api_config(scanner_config, environment)
    load_ecog_api_config(scanner_config, environment)
  end

  def load_database_config(scanner_config, environment)
    if scanner_config.has_key?('database_config_path')
      database_config = YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['database_config_path']))[environment]
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

  def load_match_api_config(scanner_config, environment)
    if scanner_config.has_key?('match_api_config_path')
      match_api_config = YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['match_api_config_path']))[environment]
      @config['match_api'] = {
          'scheme' => match_api_config['clients']['default']['scheme'],
          'hosts' => match_api_config['clients']['default']['hosts'],
          'context' => match_api_config['clients']['default']['context'],
      }
    else
      @config['match_api'] = nil
    end
  end

  def load_ecog_api_config(scanner_config, environment)
    if scanner_config.has_key?('ecog_api_config_path')
      ecog_api_config = YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['ecog_api_config_path']))[environment]
      @config['ecog_api'] = {
          'scheme' => ecog_api_config['clients']['default']['scheme'],
          'hosts' => ecog_api_config['clients']['default']['hosts'],
          'context' => ecog_api_config['clients']['default']['context'],
      }
    else
      @config['ecog_api'] = nil
    end
  end

  private :load_database_config, :load_match_api_config, :load_ecog_api_config

end