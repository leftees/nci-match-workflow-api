require 'mongoid'
require 'mongo'
require 'sinatra/reloader' if development?
require 'sinatra/base'
require 'sinatra/config_file'

require "#{File.dirname(__FILE__)}/error/rejoin_error"
require "#{File.dirname(__FILE__)}/model/patient"
require "#{File.dirname(__FILE__)}/model/patient_assignment_queue_message"
require "#{File.dirname(__FILE__)}/model/transaction_message"
require "#{File.dirname(__FILE__)}/queue/rabbit_mq_publisher"
require "#{File.dirname(__FILE__)}/util/workflow_logger"
require "#{File.dirname(__FILE__)}/validator/rejoin_matchbox_validator"

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

  get '/version' do
    content_type :json
    version = 'v.1.0.0-beta1'
    WorkflowLogger.logger.info "WORKFLOW API | Returning version '#{version}' to remote host."
    version
  end

  post '/ecog/rs/rejoin/:patientSequenceNumber' do
    content_type :json
    patientSequenceNumber = params['patientSequenceNumber']
    begin
      WorkflowLogger.logger.info "WORKFLOW API | Processing patient #{patientSequenceNumber} rejoin request ..."

      WorkflowLogger.logger.info "WORKFLOW API | Parsing patient #{patientSequenceNumber} rejoin request payload ..."
      request_data = JSON.parse(request.body.read)

      patient_docs = Patient.where(patientSequenceNumber: patientSequenceNumber)
      patient = patient_docs[0] if !patient_docs.nil? && patient_docs.size == 1

      WorkflowLogger.logger.info "WORKFLOW API | Validating patient #{patientSequenceNumber} rejoin eligibility ..."
      RejoinMatchboxValidator.new(patient, request_data).validate

      WorkflowLogger.logger.info "WORKFLOW API | Received patient #{patientSequenceNumber} payload #{request_data}."
      priorRejoinDrugs = request_data['priorRejoinDrugs'] if !request_data['priorRejoinDrugs'].nil?

      WorkflowLogger.logger.info "WORKFLOW API | Persisting patient #{patientSequenceNumber} rejoin status ..."
      patient.add_prior_drugs(priorRejoinDrugs)
      patient.add_patient_trigger('REJOIN')
      patient.set_rejoin_date
      patient.save

      WorkflowLogger.logger.info "WORKFLOW API | Enqueuing patient #{patientSequenceNumber} for treatment assignment ..."
      RabbitMQPublisher.new.enqueue_message(PatientAssignmentQueueMessage.new(patientSequenceNumber))

      WorkflowLogger.logger.info "WORKFLOW API | Processing patient rejoin request for #{patientSequenceNumber} complete."
      TransactionMessage.new('SUCCESS', "Rejoin request for patient #{patientSequenceNumber} completed.").to_json
    rescue JSON::ParserError => error
      WorkflowLogger.logger.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      WorkflowLogger.logger.error 'WORKFLOW API | Printing backtrace:'
      error.backtrace.each do |line|
        WorkflowLogger.logger.error "WORKFLOW API |   #{line}"
      end
      status 400
      body TransactionMessage.new('FAILURE', "Invalid rejoin request received. Message: #{error.message}").to_json
    rescue RejoinError => error
      WorkflowLogger.logger.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      status 400
      body TransactionMessage.new('FAILURE', "Invalid rejoin request received. Message: #{error.message}").to_json
    rescue => error
      WorkflowLogger.logger.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      WorkflowLogger.logger.error 'WORKFLOW API | Printing backtrace:'
      error.backtrace.each do |line|
        WorkflowLogger.logger.error "WORKFLOW API |   #{line}"
      end
      status 500
      body TransactionMessage.new('FAILURE', "Matchbox Server Internal Error. Message: #{error.message}").to_json
    end
  end

end