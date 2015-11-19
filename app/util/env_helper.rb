class EnvHelper
  def self.log_level
    begin
      return !ENV['LOG_LEVEL'].nil? ? Logger.const_get(ENV['LOG_LEVEL'])  : Logger::DEBUG
    rescue
      return Logger::DEBUG
    end
  end

  def self.log_filepath
    return !ENV['LOG_FILEPATH'].nil? ? ENV['LOG_FILEPATH'] : 'log/workflow-api.log'
  end
end