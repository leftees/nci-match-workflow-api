require 'bundler'
require 'mongoid'

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

configure {Mongoid.load!('/local/content/ncimatch/conf/ruby/mongoid-match-prodtest.yml', :prodtest)}
