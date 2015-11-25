require "#{File.dirname(__FILE__)}/../../../app/util/env_helper"

RSpec.describe EnvHelper, '.log_level' do
  after(:each) do
    ENV.delete('LOG_LEVEL')
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
