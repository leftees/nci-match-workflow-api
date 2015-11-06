require 'sinatra/reloader' if development?
require 'sinatra/base'
require 'sinatra/config_file'

require "#{File.dirname(__FILE__)}/util/workflow_logger"

class WorkflowApi < Sinatra::Base
  register Sinatra::ConfigFile, Sinatra::Reloader

  WorkflowLogger.log.info "============ Current environment: #{ENV['RACK_ENV']}"

  configure do
    enable :logging
    set :protection, :except => [:json_csrf]
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers 'Access-Control-Allow-Methods' => 'GET'
  end

  get '/version' do
    content_type :json
    version = 'v.1.0.0-beta1'
    WorkflowLogger.log.info "WORKFLOW API | Returning version '#{version}' to remote host."
    version
  end

  post '/rejoin/:patientSequenceNumber' do
    content_type :json
    patientSequenceNumber = params['patientSequenceNumber']
    begin
      data = JSON.parse(request.body.read)

      WorkflowLogger.log.error "WORKFLOW API | Received rejoin request for patient #{patientSequenceNumber}."
      WorkflowLogger.log.error "WORKFLOW API | Processing rejoin request #{data} ..."

      # Implement rejoin logic here

      WorkflowLogger.log.error "WORKFLOW API | Processing rejoin request for patient #{patientSequenceNumber}."
    rescue JSON::ParserError => error
      status 400
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
    rescue => error
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      status 500
    end
  end

end