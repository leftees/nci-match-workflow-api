require 'bundler'
require 'mongoid'

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

configure {Mongoid.load!(File.dirname(__FILE__) + '/../mongoid-dev.yml', :development)}