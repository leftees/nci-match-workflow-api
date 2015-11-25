require "#{File.dirname(__FILE__)}/../../../app/queue/rabbit_mq_publisher"

class BunnyStub
  def start ; end
  def create_channel ; end
  def close ; end
end

class ChannelStub
  def queue(name, opts) ; end
  def default_exchange ; end
end

class QueueStub
  def name ; end
end

class ExchangeStub
  def publish(message, opts) ; end
end

RSpec.describe RabbitMQPublisher, '#enqueue_message' do
  before(:each) do
    allow(WorkflowLogger.logger).to receive(:info) do
      # stubbing out the info logger
    end
    allow(WorkflowLogger.logger).to receive(:error) do
      # stubbing out the error logger
    end
    allow(WorkflowLogger.logger).to receive(:debug) do
      # stubbing out the debug logger
    end
  end

  context 'a patient rejoin matchbox message' do
    it 'should place the message on the queue without a problem' do
      queue_stub = QueueStub.new
      exchange_stub = ExchangeStub.new

      channel_stub = ChannelStub.new
      allow(channel_stub).to receive(:queue) do | queue_name, opts |
        queue_stub
      end
      allow(channel_stub).to receive(:default_exchange) do
        exchange_stub
      end

      bunny_stub = BunnyStub.new
      allow(Bunny).to receive(:new).and_return(bunny_stub)
      allow(bunny_stub).to receive(:create_channel) do
        channel_stub
      end

      expect { RabbitMQPublisher.new.enqueue_message({ 'patientSequenceNumber' => '1234' }) }.to_not raise_error
    end
  end

  context 'a patient rejoin matchbox message with tcp connection issue' do
    it 'should raise an error ' do
      bunny_stub = BunnyStub.new
      allow(Bunny).to receive(:new).and_return(bunny_stub)
      allow(bunny_stub).to receive(:start) do
        raise Bunny::TCPConnectionFailed, 'Failed to establish tcp connection to RabbitMQ'
      end
      expect { RabbitMQPublisher.new.enqueue_message({ 'patientSequenceNumber' => '1234' }) }.to raise_error(Bunny::TCPConnectionFailed)
    end
  end

  context 'a patient rejoin matchbox message with channel issue' do
    it 'should raise an error ' do
      channel_stub = ChannelStub.new
      allow(channel_stub).to receive(:queue) do | queue_name, opts |
        raise Bunny::AccessRefused.new('Failed to access RabbitMQ queue.', nil, nil)
      end

      bunny_stub = BunnyStub.new
      allow(Bunny).to receive(:new).and_return(bunny_stub)
      allow(bunny_stub).to receive(:create_channel) do
        channel_stub
      end

      expect { RabbitMQPublisher.new.enqueue_message({ 'patientSequenceNumber' => '1234' }) }.to raise_error(Bunny::AccessRefused)
    end
  end
end