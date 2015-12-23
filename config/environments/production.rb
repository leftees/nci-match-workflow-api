require 'bundler'
require 'mongoid'

require "#{File.dirname(__FILE__)}/../../app/queue/rabbit_mq"
require "#{File.dirname(__FILE__)}/../../app/util/workflow_api_config"

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

configure { WorkflowApiConfig.load!(File.dirname(__FILE__) + '/../workflow-api.yml', :production) }
configure { Mongoid.load!('/local/content/ncimatch/conf/ruby/mongoid-match-prod.yml', :production) }
configure { RabbitMQ.load!('/local/content/ncimatch/conf/ruby/rabbitmq-match-prod.yml', :production) }
