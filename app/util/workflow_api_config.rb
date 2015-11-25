class WorkflowApiConfig
  @@log_level = Logger::DEBUG

  def self.load!(ymlPath, env)
    @@workflow_api_config = YAML.load_file(ymlPath)[env.to_s] rescue nil
    @@log_level = Logger.const_get(@@workflow_api_config['log_level']) rescue Logger::DEBUG
  end

  def self.log_level
    @@log_level
  end
end