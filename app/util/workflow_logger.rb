require 'logger'

class WorkflowLogger
  def self.logger
    if @logger.nil?
      @logger = Logger.new(EnvHelper.log_filepath, 3, 100 * 1024 * 1024)
      @logger.level = EnvHelper.log_level
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end
end