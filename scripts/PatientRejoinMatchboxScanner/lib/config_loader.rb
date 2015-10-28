class ConfigLoader
  attr_reader :config

  def initialize(configPath, mode)
    mode = 'development' if mode.nil?
    @config = YAML.load_file(File.join(File.dirname(__FILE__), configPath))[mode]
  end

end