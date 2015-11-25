require "#{File.dirname(__FILE__)}/../../../app/queue/rabbit_mq_publisher"

RSpec.describe RabbitMQPublisher, '#enqueue_message' do
  context 'a patient rejoin matchbox message' do
    it 'should place the message on the queue without a problem' do

    end
  end

  context 'a patient rejoin matchbox message with connection issue' do
    it 'should raise an error ' do

    end
  end

  context 'a patient rejoin matchbox message with channel issue' do
    it 'should raise an error ' do

    end
  end

  context 'a patient rejoin matchbox message with delay exchange issue' do
    it 'should raise an error ' do

    end
  end
end