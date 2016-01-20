require 'bundler'
require 'mongoid'

require "#{File.dirname(__FILE__)}/../../app/queue/rabbit_mq"
require "#{File.dirname(__FILE__)}/../../app/util/workflow_api_config"
require "#{File.dirname(__FILE__)}/../../app/util/filesystem_config"

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

configure { WorkflowApiConfig.load!(File.dirname(__FILE__) + '/../workflow-api.yml', :prodtest) }
configure { Mongoid.load!('/local/content/ncimatch/conf/ruby/mongoid-match-prodtest.yml', :prodtest) }
configure { RabbitMQ.load!('/local/content/ncimatch/conf/ruby/rabbitmq-match-prodtest.yml', :prodtest) }
configure { FileSystemConfig.load!('/local/content/ncimatch/conf/ruby/filesystem-config-prodtest.yml', :prodtest) }
