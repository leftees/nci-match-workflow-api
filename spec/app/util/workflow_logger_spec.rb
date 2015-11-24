require "#{File.dirname(__FILE__)}/../../../app/util/workflow_logger"

RSpec.describe WorkflowLogger, '.logger' do
  after(:each) do
    ENV.delete('LOG_LEVEL')
    ENV.delete('LOG_FILEPATH')
  end

  context 'with default environment settings' do
    it 'should return logger using default settings' do
      expect(WorkflowLogger.logger.level).to eq(Logger::DEBUG)
      expect(WorkflowLogger.logger.datetime_format).to eq('%Y-%m-%d %H:%M:%S ')
      expect(WorkflowLogger.logger.instance_variable_get(:'@logdev').filename).to eq('log/workflow-api.log')
    end
  end
end
