require 'bundler'
require 'mongoid'

require "#{File.dirname(__FILE__)}/../../app/queue/rabbit_mq"

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

configure { Mongoid.load!(File.dirname(__FILE__) + '/../mongoid-dev.yml', :development) }
configure { RabbitMQ.load!(File.dirname(__FILE__) + '/../rabbitmq-dev.yml', :development) }