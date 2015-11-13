require 'sinatra/reloader' if development?
require 'sinatra/base'
require 'sinatra/config_file'

require "#{File.dirname(__FILE__)}/model/patient"
require "#{File.dirname(__FILE__)}/model/patient_rejoin_log"
require "#{File.dirname(__FILE__)}/util/workflow_logger"
require "#{File.dirname(__FILE__)}/error/rejoin_error"

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
      data = JSON.parse(request.body.read)

      WorkflowLogger.log.error "WORKFLOW API | Processing patient #{patientSequenceNumber} rejoin request #{data} ..."

      rejoin_docs = PatientRejoinLog.where(patientSequenceNumber: patientSequenceNumber)
      rejoin_patient = rejoin_docs[0] if !rejoin_docs.nil? && rejoin_docs.size == 1

      if rejoin_patient.nil?
        raise RejoinError, "No rejoin log entry exist for patient #{patientSequenceNumber}."
      end

      patient_docs = Patient.where(patientSequenceNumber: patientSequenceNumber)
      patient = patient_docs[0] if !patient_docs.nil? && patient_docs.size == 1

      if patient.nil?
        raise RejoinError, "Patient #{patientSequenceNumber} does not exist in Matchbox."
      end

      if patient['currentPatientStatus'] != 'OFF_TRIAL_NO_TA_AVAILABLE' || patient['currentStepNumber'] != '0'
        raise RejoinError, "Patient #{patientSequenceNumber} current status is #{patient['currentPatientStatus']} and step number is #{patient['currentStepNumber']}."
      end

      patient.addPriorRejoinDrugs(data)
      patient.addRejoinPatientTrigger()
      #patient.save!

      # TODO: Place the patient on RabbitMQ queue.

      WorkflowLogger.log.info "WORKFLOW API | Processing patient rejoin request for #{patientSequenceNumber} complete."

      patient.to_json
    rescue JSON::ParserError => error
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      status 400
    rescue RejoinError => error
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      status 400
    rescue => error
      WorkflowLogger.log.error "WORKFLOW API | Failed to process rejoin request for #{patientSequenceNumber}. Message: #{error.message}"
      status 500
    end
  end

end