require 'sinatra/reloader' if development?
require 'sinatra/base'
require 'sinatra/config_file'

require "#{File.dirname(__FILE__)}/error/rejoin_error"
require "#{File.dirname(__FILE__)}/model/patient"
require "#{File.dirname(__FILE__)}/util/workflow_logger"
require "#{File.dirname(__FILE__)}/validator/rejoin_matchbox_validator"

class WorkflowApi < Sinatra::Base
  register Sinatra::ConfigFile, Sinatra::Reloader

  WorkflowLogger.log.info "WORKFLOW API | Running in environment: #{ENV['RACK_ENV']}"

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

  post '/ecog/rs/rejoin/:patientSequenceNumber' do
    content_type :json
    patientSequenceNumber = params['patientSequenceNumber']
    begin
      WorkflowLogger.log.info "WORKFLOW API | Processing patient #{patientSequenceNumber} rejoin request ..."

      WorkflowLogger.log.info "WORKFLOW API | Parsing patient #{patientSequenceNumber} rejoin request payload ..."
      request_data = JSON.parse(request.body.read)

      patient_docs = Patient.where(patientSequenceNumber: patientSequenceNumber)
      patient = patient_docs[0] if !patient_docs.nil? && patient_docs.size == 1

      WorkflowLogger.log.info "WORKFLOW API | Validating patient #{patientSequenceNumber} rejoin eligibility ..."
      RejoinMatchboxValidator.new(patient, request_data).validate

      WorkflowLogger.log.info "WORKFLOW API | Received patient #{patientSequenceNumber} payload #{request_data}."
      priorRejoinDrugs = request_data['priorRejoinDrugs'] if !request_data['priorRejoinDrugs'].nil?

      patient.add_prior_drugs(priorRejoinDrugs)
      patient.add_patient_trigger('REJOIN')
      patient.set_rejoin_date
      patient.save

      # TODO: Place the patient on RabbitMQ queue.

      WorkflowLogger.log.info "WORKFLOW API | Processing patient rejoin request for #{patientSequenceNumber} complete."

      patient.to_json
    rescue JSON::ParserError => error
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      WorkflowLogger.log.error 'WORKFLOW API | Printing backtrace:'
      error.backtrace.each do |line|
        WorkflowLogger.log.error "WORKFLOW API |   #{line}"
      end
      status 400
    rescue RejoinError => error
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      WorkflowLogger.log.error 'WORKFLOW API | Printing backtrace:'
      error.backtrace.each do |line|
        WorkflowLogger.log.error "WORKFLOW API |   #{line}"
      end
      status 400
    rescue => error
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      WorkflowLogger.log.error 'WORKFLOW API | Printing backtrace:'
      error.backtrace.each do |line|
        WorkflowLogger.log.error "WORKFLOW API |   #{line}"
      end
      status 500
    end
  end

end