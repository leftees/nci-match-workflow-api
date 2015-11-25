require "#{File.dirname(__FILE__)}/../../../app/util/workflow_logger"

RSpec.describe WorkflowLogger, '.logger' do
  context 'with default environment settings' do
    it 'should return logger using default settings' do
      expect(WorkflowLogger.logger.level).to eq(Logger::DEBUG)
      expect(WorkflowLogger.logger.datetime_format).to eq('%Y-%m-%d %H:%M:%S ')
    end
  end
end
