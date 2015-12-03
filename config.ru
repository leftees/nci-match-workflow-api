require 'sinatra'

configure(:development){
  puts '============> Running in developement environment'
  require './config/environments/development.rb'
}

configure(:prodtest){
  puts '============> Running in prod test environment'
  require './config/environments/prodtest.rb'
}

configure(:production){
  puts '===========> Running in production environment'
  require './config/environments/production.rb'
}

if !Dir.exist? 'log'
  Dir.mkdir 'log'
end

root = ::File.dirname(__FILE__)
logfile = ::File.join(root, 'log', 'access.log')

require 'logger'
class ::Logger; alias_method :write, :<<; end
logger = ::Logger.new(logfile, 'weekly')

use Rack::CommonLogger, logger

require './app/workflow_api.rb'
run WorkflowApi