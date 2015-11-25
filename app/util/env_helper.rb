class EnvHelper
  def self.log_level
    begin
      return !ENV['LOG_LEVEL'].nil? ? Logger.const_get(ENV['LOG_LEVEL'])  : Logger::DEBUG
    rescue
      return Logger::DEBUG
    end
  end
end