require "#{File.dirname(__FILE__)}/../../../app/util/workflow_api_config"

RSpec.describe WorkflowApiConfig, '.load!' do
  context 'with a yml file that does not exist' do
    it 'should return log level DEBUG' do
      WorkflowApiConfig.load!('/tmp/workflow-api/config/workflow-api.yml', :development)
      expect(WorkflowApiConfig.log_level).to eq(Logger::DEBUG)
    end
  end

  context 'a envrionment that does not exist' do
    it 'should return log level DEBUG' do
      WorkflowApiConfig.load!('spec/resource/workflow-api-unittest.yml', :bogus_env)
      expect(WorkflowApiConfig.log_level).to eq(Logger::DEBUG)
    end
  end

  context 'with a yml file for a development environment' do
    it 'should return log level DEBUG' do
      WorkflowApiConfig.load!('spec/resource/workflow-api-unittest.yml', :development)
      expect(WorkflowApiConfig.log_level).to eq(Logger::DEBUG)
    end
  end

  context 'with a yml file for a prodtest environment' do
    it 'should return log level INFO' do
      WorkflowApiConfig.load!('spec/resource/workflow-api-unittest.yml', :prodtest)
      expect(WorkflowApiConfig.log_level).to eq(Logger::INFO)
    end
  end

  context 'with a yml file for a production environment' do
    it 'should return log level WARN' do
      WorkflowApiConfig.load!('spec/resource/workflow-api-unittest.yml', :production)
      expect(WorkflowApiConfig.log_level).to eq(Logger::WARN)
    end
  end
end