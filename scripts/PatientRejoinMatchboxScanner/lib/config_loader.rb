require 'pathname'

class ConfigLoader
  attr_reader :config, :redacted_config

  def initialize(configPath, environment)
    @config = {}
    @redacted_config = {}

    environment = ENV['SCANNER_ENV'] if !environment.nil? && !ENV['SCANNER_ENV'].nil?
    environment = 'development' if environment.nil?

    scanner_config = YAML.load_file(File.join(File.dirname(__FILE__), configPath))[environment]

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
      database_config = Pathname.new(scanner_config['database_config_path']).relative? ?
          YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['database_config_path']))[environment] :
          YAML.load_file(scanner_config['database_config_path'])[environment]
      username = database_config['clients']['default']['options']['user'] rescue nil
      password = database_config['clients']['default']['options']['password'] rescue nil
      @config['database'] = {
          'hosts' => database_config['clients']['default']['hosts'],
          'dbname' => database_config['clients']['default']['database'],
          'username' => username,
          'password' => password
      }
      @redacted_config['database'] = {
          'hosts' => database_config['clients']['default']['hosts'],
          'dbname' => database_config['clients']['default']['database'],
          'username' => '********',
          'password' => '********'
      }
    else
      @config['database'] = nil
    end
  end

  def load_match_api_config(scanner_config, environment)
    if scanner_config.has_key?('match_api_config_path')
      match_api_config = Pathname.new(scanner_config['match_api_config_path']).relative? ?
          YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['match_api_config_path']))[environment] :
          YAML.load_file(scanner_config['match_api_config_path'])[environment]
      username = match_api_config['clients']['default']['options']['user'] rescue nil
      password = match_api_config['clients']['default']['options']['password'] rescue nil
      @config['match_api'] = {
          'scheme' => match_api_config['clients']['default']['scheme'],
          'hosts' => match_api_config['clients']['default']['hosts'],
          'context' => match_api_config['clients']['default']['context'],
          'username' => username,
          'password' => password
      }
      @redacted_config['match_api'] = {
          'scheme' => match_api_config['clients']['default']['scheme'],
          'hosts' => match_api_config['clients']['default']['hosts'],
          'context' => match_api_config['clients']['default']['context'],
          'username' => '********',
          'password' => '********'
      }
    else
      @config['match_api'] = nil
    end
  end

  def load_ecog_api_config(scanner_config, environment)
    if scanner_config.has_key?('ecog_api_config_path')
      ecog_api_config = Pathname.new(scanner_config['ecog_api_config_path']).relative? ?
          YAML.load_file(File.join(File.dirname(__FILE__), scanner_config['ecog_api_config_path']))[environment] :
          YAML.load_file(scanner_config['ecog_api_config_path'])[environment]
      username = ecog_api_config['clients']['default']['options']['user'] rescue nil
      password = ecog_api_config['clients']['default']['options']['password'] rescue nil
      @config['ecog_api'] = {
          'scheme' => ecog_api_config['clients']['default']['scheme'],
          'hosts' => ecog_api_config['clients']['default']['hosts'],
          'context' => ecog_api_config['clients']['default']['context'],
          'username' => username,
          'password' => password
      }
      @redacted_config['ecog_api'] = {
          'scheme' => ecog_api_config['clients']['default']['scheme'],
          'hosts' => ecog_api_config['clients']['default']['hosts'],
          'context' => ecog_api_config['clients']['default']['context'],
          'username' => '********',
          'password' => '********'
      }
    else
      @config['ecog_api'] = nil
    end
  end

  private :load_database_config, :load_match_api_config, :load_ecog_api_config

end