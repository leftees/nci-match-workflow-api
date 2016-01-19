require 'bundler'
require 'mongoid'

require "#{File.dirname(__FILE__)}/../../app/queue/rabbit_mq"
require "#{File.dirname(__FILE__)}/../../app/util/workflow_api_config"
require "#{File.dirname(__FILE__)}/../../app/util/filesystem_config"

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

configure { WorkflowApiConfig.load!(File.dirname(__FILE__) + '/../workflow-api.yml', :development) }
configure { Mongoid.load!(File.dirname(__FILE__) + '/../mongoid-dev.yml', :development) }
configure { RabbitMQ.load!(File.dirname(__FILE__) + '/../rabbitmq-dev.yml', :development) }
configure { FileSystemConfig.load!(File.dirname(__FILE__) + '/../filesystem-config-dev.yml', :development) }
