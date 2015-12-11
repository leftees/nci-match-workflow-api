module Sinatra
  module WorkflowApi
    module ECOGMessagingService

      def self.registered(service)

        service.post '/setPatientTrigger' do
          status 501
        end

        service.post '/setPatientAssignmentStatus' do
          status 501
        end

        service.post '/ecog/rs/rejoin/:patientSequenceNumber' do
          content_type :json
          patientSequenceNumber = params['patientSequenceNumber']
          begin
            WorkflowLogger.logger.info "WORKFLOW API | Processing patient #{patientSequenceNumber} rejoin request ..."

            WorkflowLogger.logger.info "WORKFLOW API | Parsing patient #{patientSequenceNumber} rejoin request payload ..."
            request_data = ::JSON.parse(request.body.read)

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
          rescue ::JSON::ParserError => error
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

    end
  end
end
