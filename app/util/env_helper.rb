class EnvHelper
  def self.log_level
    begin
      return Logger.const_get(ENV['LOG_LEVEL']) ? !ENV['LOG_LEVEL'].nil? : Logger::DEBUG
    rescue
      return Logger::DEBUG
    end
  end

  def self.log_filepath
    return ENV['LOG_FILEPATH'] ? !ENV['LOG_FILEPATH'].nil? : 'log/workflow-api.log'
  end
end