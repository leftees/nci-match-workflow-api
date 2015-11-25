require "#{File.dirname(__FILE__)}/../../../app/queue/rabbit_mq"

RSpec.describe RabbitMQ, '.load' do
  context 'a rabbitmq yml file that does not exist' do
    it 'should uses the default values' do
      RabbitMQ.load!('/tmp/workflow-api/config/rabbitmq.yml','development')

      expect(RabbitMQ.hosts).to eq(['127.0.0.1:5672'])
      expect(RabbitMQ.vhost).to eq('/')
      expect(RabbitMQ.queue_name).to eq('matchTest')
      expect(RabbitMQ.username).to be_nil
      expect(RabbitMQ.password).to be_nil

      expect(RabbitMQ.connection_config[:hosts]).to eq(['127.0.0.1:5672'])
      expect(RabbitMQ.connection_config[:vhost]).to eq('/')
      expect(RabbitMQ.connection_config[:user]).to be_nil
      expect(RabbitMQ.connection_config[:password]).to be_nil
      expect(RabbitMQ.connection_config[:logger]).not_to be_nil
      expect(RabbitMQ.connection_config[:log_level]).to be(Logger::DEBUG)
    end
  end

  context 'a rabbitmq yml file but environment does not exist' do
    it 'should uses the default values' do
      RabbitMQ.load!('spec/resource/rabbitmq-unittest.yml','no_such_env')

      expect(RabbitMQ.hosts).to eq(['127.0.0.1:5672'])
      expect(RabbitMQ.vhost).to eq('/')
      expect(RabbitMQ.queue_name).to eq('matchTest')
      expect(RabbitMQ.username).to be_nil
      expect(RabbitMQ.password).to be_nil

      expect(RabbitMQ.connection_config[:hosts]).to eq(['127.0.0.1:5672'])
      expect(RabbitMQ.connection_config[:vhost]).to eq('/')
      expect(RabbitMQ.connection_config[:user]).to be_nil
      expect(RabbitMQ.connection_config[:password]).to be_nil
      expect(RabbitMQ.connection_config[:logger]).not_to be_nil
      expect(RabbitMQ.connection_config[:log_level]).to be(Logger::DEBUG)
    end
  end

  context 'a rabbitmq yml file that exist' do
    it 'should store the values from the yml file' do
      RabbitMQ.load!('spec/resource/rabbitmq-unittest.yml','unittest')

      expect(RabbitMQ.hosts).to eq(['unittest1:5672','unittest2:5672','unittest3:5672'])
      expect(RabbitMQ.vhost).to eq('ut_vhost')
      expect(RabbitMQ.queue_name).to eq('ut_queue')
      expect(RabbitMQ.username).to eq('ut_username')
      expect(RabbitMQ.password).to eq('ut_password')

      expect(RabbitMQ.connection_config[:hosts]).to eq(['unittest1:5672','unittest2:5672','unittest3:5672'])
      expect(RabbitMQ.connection_config[:vhost]).to eq('ut_vhost')
      expect(RabbitMQ.connection_config[:user]).to eq('ut_username')
      expect(RabbitMQ.connection_config[:password]).to eq('ut_password')
      expect(RabbitMQ.connection_config[:logger]).not_to be_nil
      expect(RabbitMQ.connection_config[:log_level]).to be(Logger::DEBUG)
    end
  end
end