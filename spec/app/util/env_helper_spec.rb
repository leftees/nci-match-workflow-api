require "#{File.dirname(__FILE__)}/../../../app/util/env_helper"

RSpec.describe EnvHelper, '.log_level' do
  after(:each) do
    ENV.delete('LOG_LEVEL')
    ENV.delete('LOG_FILEPATH')
  end

  context 'with LOG_LEVEL environment variable not set' do
    it 'should return Logger::DEBUG' do
      expect(EnvHelper.log_level).to eq(Logger::DEBUG)
    end
  end

  context 'with LOG_LEVEL environment variable set to INFO' do
    it 'should return Logger::INFO' do
      ENV['LOG_LEVEL'] = 'INFO'
      expect(EnvHelper.log_level).to eq(Logger::INFO)
    end
  end

  context 'with LOG_LEVEL environment variable set to an invalid value' do
    it 'should return Logger::DEBUG' do
      ENV['LOG_LEVEL'] = 'INVALID_LOG_LEVEL'
      expect(EnvHelper.log_level).to eq(Logger::DEBUG)
    end
  end
end

RSpec.describe EnvHelper, '.log_filepath' do
  after(:each) do
    ENV.delete('LOG_LEVEL')
    ENV.delete('LOG_FILEPATH')
  end

  context 'with LOG_FILEPATH environment not set' do
    it 'should return log/workflow-api.log' do
      expect(EnvHelper.log_filepath).to eq('log/workflow-api.log')
    end
  end

  context 'with LOG_FILEPATH environment set to /tmp/log/workflow-api.log' do
    it 'should return /tmp/log/workflow-api.log' do
      ENV['LOG_FILEPATH'] = '/tmp/log/workflow-api.log'
      expect(EnvHelper.log_filepath).to eq('/tmp/log/workflow-api.log')
    end
  end
end
