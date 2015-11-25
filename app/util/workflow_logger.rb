require 'logger'

class WorkflowLogger
  def self.logger
    if @logger.nil?
      @logger = Logger.new STDOUT
      @logger.level = EnvHelper.log_level
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end
end