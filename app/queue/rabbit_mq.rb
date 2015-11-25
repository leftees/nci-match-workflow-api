class RabbitMQ
  def self.load!(ymlPath, env)
    @@rabbitmq_config = YAML.load_file(ymlPath)[env.to_s] rescue nil

    default_hosts = [ '127.0.0.1:5672' ]
    default_vhost = '/'
    default_queue_name = 'matchTest'

    @@hosts = @@rabbitmq_config['clients']['default']['hosts'] rescue default_hosts
    @@hosts = default_hosts if @@hosts.nil?

    @@vhost = @@rabbitmq_config['clients']['default']['vhost'] rescue default_vhost
    @@vhost = default_vhost if @@vhost.nil?

    @@queue_name = @@rabbitmq_config['clients']['default']['queue_name'] rescue default_queue_name
    @@queue_name = default_queue_name if @@queue_name.nil?

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
    return {
        :hosts => @@hosts,
        :vhost => @@vhost,
        :user => @@username,
        :password => @@password,
        :logger => WorkflowLogger.logger,
        :log_level => EnvHelper.log_level
    }
  end
end