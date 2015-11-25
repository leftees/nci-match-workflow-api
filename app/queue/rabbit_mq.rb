class RabbitMQ
  @@hosts = [ '127.0.0.1:5672' ]
  @@vhost = '/'
  @@queue_name = 'matchTest'
  @@username = nil
  @@password = nil

  def self.load!(ymlPath, env)
    @@rabbitmq_config = YAML.load_file(ymlPath)[env.to_s] rescue nil

    @@hosts = @@rabbitmq_config['clients']['default']['hosts'] rescue [ '127.0.0.1:5672' ]
    @@vhost = @@rabbitmq_config['clients']['default']['vhost'] rescue '/'
    @@queue_name = @@rabbitmq_config['clients']['default']['queue_name'] rescue 'matchTest'
    @@username = @@rabbitmq_config['clients']['default']['username'] rescue nil
    @@password = @@rabbitmq_config['clients']['default']['password'] rescue nil
  end

  def self.hosts
    return @@hosts
  end

  def self.vhost
    return @@vhost
  end

  def self.queue_name
    return @@queue_name
  end

  def self.username
    return @@username
  end

  def self.password
    return @@password
  end

  def self.connection_config
    # TODO: Test setting :automatic_recovery => false
    return {
        :hosts => @@hosts,
        :vhost => @@vhost,
        :user => @@username,
        :password => @@password,
        :logger => WorkflowLogger.logger,
        :log_level => WorkflowApiConfig.log_level
    }
  end
end