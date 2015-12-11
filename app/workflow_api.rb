require 'mongoid'
require 'mongo'
require 'sinatra/reloader' if development?
require 'sinatra/base'
require 'sinatra/config_file'

require "#{File.dirname(__FILE__)}/error/rejoin_error"
require "#{File.dirname(__FILE__)}/model/patient"
require "#{File.dirname(__FILE__)}/model/patient_assignment_queue_message"
require "#{File.dirname(__FILE__)}/model/transaction_message"
require "#{File.dirname(__FILE__)}/model/version"
require "#{File.dirname(__FILE__)}/queue/rabbit_mq_publisher"
require "#{File.dirname(__FILE__)}/util/workflow_logger"
require "#{File.dirname(__FILE__)}/validator/rejoin_matchbox_validator"

require_relative 'service/clia_messaging_service'
require_relative 'service/ecog_messaging_service'
require_relative 'service/match_service'
require_relative 'service/mda_messaging_service'

class WorkflowApi < Sinatra::Base

  register Sinatra::ConfigFile, Sinatra::Reloader

  WorkflowLogger.logger.info '========== WORKFLOW API | Starting Workflow API Restful Services  =========='
  WorkflowLogger.logger.info "WORKFLOW API | Running in environment: #{ENV['RACK_ENV']}"

  configure do
    enable :logging
    set :protection, :except => [:json_csrf]
    Mongo::Logger.logger = WorkflowLogger.logger
    Mongo::Logger.logger.level = WorkflowApiConfig.log_level
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers 'Access-Control-Allow-Methods' => 'GET'
  end

  register Sinatra::WorkflowApi::ECOGMessagingService
  register Sinatra::WorkflowApi::MDAMessagingService
  register Sinatra::WorkflowApi::CLIAMessagingService
  register Sinatra::WorkflowApi::MatchService

end
