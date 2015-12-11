class RabbitMQ
  @@hosts = [ '127.0.0.1:5672' ]
  @@vhost = '/'
  @@queue_name = 'matchTest'
  @@username = nil
  @@password = nil
  @@use_ssl = false
  @@verify_peer = false

  def self.load!(ymlPath, env)
    @@rabbitmq_config = YAML.load_file(ymlPath)[env.to_s] rescue nil

    @@hosts = @@rabbitmq_config['clients']['default']['hosts'] rescue [ '127.0.0.1:5672' ]
    @@vhost = @@rabbitmq_config['clients']['default']['vhost'] rescue '/'
    @@queue_name = @@rabbitmq_config['clients']['default']['queue_name'] rescue 'matchTest'
    @@username = @@rabbitmq_config['clients']['default']['username'] rescue nil
    @@password = @@rabbitmq_config['clients']['default']['password'] rescue nil
    @@use_ssl = @@rabbitmq_config['clients']['default']['use_ssl'] rescue false
    @@verify_peer = @@rabbitmq_config['clients']['default']['verify_peer'] rescue false
  end

  def self.hosts
    @@hosts
  end

  def self.vhost
    @@vhost
  end

  def self.queue_name
    @@queue_name
  end

  def self.username
    @@username
  end

  def self.password
    @@password
  end

  def self.use_ssl
    @@use_ssl
  end

  def self.verify_peer
    @@verify_peer
  end

  def self.connection_config
    # TODO: Test setting :automatic_recovery => false
    return {
        :hosts => @@hosts,
        :vhost => @@vhost,
        :user => @@username,
        :password => @@password,
        :ssl => @@use_ssl,
        :verify_peer => @@verify_peer,
        :logger => WorkflowLogger.logger,
        :log_level => WorkflowApiConfig.log_level
    }
  end
end