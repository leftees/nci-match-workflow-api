require 'bunny'

require "#{File.dirname(__FILE__)}/../util/workflow_logger"

class RabbitMQPublisher
  def enqueue_message(message)
    begin
      WorkflowLogger.logger.info 'WORKFLOW API | Connecting to RabbitMQ ...'
      connect
      WorkflowLogger.logger.info "WORKFLOW API | Enqueuing message #{message.to_json} on #{RabbitMQ.queue_name}."
      publish(message)
    ensure
      if @conn
        WorkflowLogger.logger.info 'WORKFLOW API | Closing RabbitMQ connection ... '
        @conn.close
      end
    end
  end

  def connect
    WorkflowLogger.logger.debug "WORKFLOW API | Using RabbitMQ connection config: #{RabbitMQ.connection_config}"

    conn_tries = 0
    while conn_tries < 3 do
      begin
        @conn = Bunny.new(RabbitMQ.connection_config)
        @conn.start
        break
      rescue => error
        WorkflowLogger.logger.error "WORKFLOW API | Failed to connect to RabbitMQ. Message: #{error.message}"
        WorkflowLogger.logger.error 'WORKFLOW API | Printing backtrace:'
        error.backtrace.each do |line|
          WorkflowLogger.logger.error "WORKFLOW API |   #{line}"
        end
        conn_tries += 1
        raise error if conn_tries >= 3
        sleep 1
      end
    end
  end

  def publish(message)
    enqueue_tries = 0
    while enqueue_tries < 3 do
      begin
        channel = @conn.create_channel
        queue = channel.queue(RabbitMQ.queue_name, :durable => true)
        exchange  = channel.default_exchange
        exchange.publish(message.to_json, :routing_key => queue.name)
        break
      rescue => error
        WorkflowLogger.logger.error "WORKFLOW API | Failed to enqueue patient #{message.to_json}. Message: #{error.message}"
        WorkflowLogger.logger.error 'WORKFLOW API | Printing backtrace:'
        error.backtrace.each do |line|
          WorkflowLogger.logger.error "WORKFLOW API |   #{line}"
        end
        enqueue_tries += 1
        raise error if enqueue_tries >= 3
        sleep 1
      end
    end
  end

  private :connect, :publish
end