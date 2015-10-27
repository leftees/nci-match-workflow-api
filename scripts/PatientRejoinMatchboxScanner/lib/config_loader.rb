class ConfigLoader
  attr_reader :hostname, :port, :dbname, :username, :password

  @hostname = '127.0.0.1'
  @port = '27017'
  @dbname = 'match'

  def initialize(configPath, mode)
    mode = 'development' if mode.nil?
    config = YAML.load_file(File.join(File.dirname(__FILE__), configPath))

    @hostname = config[mode]['hostname'] if config.has_key?(mode) && config[mode].has_key?('hostname')
    @port = config[mode]['port'] if config.has_key?(mode) && config[mode].has_key?('port')
    @dbname = config[mode]['dbname'] if config.has_key?(mode) && config[mode].has_key?('dbname')
    @username = config[mode]['username'] if config.has_key?(mode) && config[mode].has_key?('username')
    @password = config[mode]['password'] if config.has_key?(mode) && config[mode].has_key?('password')
  end

end