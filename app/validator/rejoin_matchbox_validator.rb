require "#{File.dirname(__FILE__)}/../error/rejoin_error"

class RejoinMatchboxValidator

  def initialize(patient, request_data)
    @patient = patient
    @request_data = request_data
  end

  def validate
    validate_patient_current_state
    validate_patient_rejoin_triggers
    validate_request_data
  end

  def validate_patient_current_state
    if @patient.nil?
      raise RejoinError, 'Patient does not exist in Matchbox.'
    end

    if @patient['currentPatientStatus'].nil? || @patient['currentStepNumber'].nil?
      raise RejoinError, "Patient #{@patient['patientSequenceNumber']} current status and/or step number is nil."
    end

    if @patient['currentPatientStatus'] != 'OFF_TRIAL_NO_TA_AVAILABLE' || @patient['currentStepNumber'] != '0'
      raise RejoinError, "Patient #{@patient['patientSequenceNumber']} current status is #{@patient['currentPatientStatus']} and step number is #{@patient['currentStepNumber']}."
    end
  end

  def validate_patient_rejoin_triggers
    if @patient['patientRejoinTriggers'].nil? || @patient['patientRejoinTriggers'].size == 0
      raise RejoinError, "No rejoin trigger exist for patient #{@patient['patientSequenceNumber']}."
    end

    rejoin_trigger = @patient['patientRejoinTriggers'][@patient['patientRejoinTriggers'].size - 1]
    if !rejoin_trigger['dateRejoined'].nil?
      raise RejoinError, "Latest patient #{@patient['patientSequenceNumber']} rejoin trigger has already been proceed, no pending rejoin trigger exist."
    end
  end

  def validate_request_data
    if !@request_data.nil? && !@request_data['priorRejoinDrugs'].nil? && @request_data['priorRejoinDrugs'].size > 0
      @request_data['priorRejoinDrugs'].each do |drugCombo|
        if !drugCombo['drugs'].nil? || drugCombo['drugs'].size > 0
          drugCombo['drugs'].each do |drug|
            if drug['drugId'].nil? || drug['drugId'].empty?
              raise RejoinError, "Rejoin request for patient #{@patient['patientSequenceNumber']} contains a prior drug that is missing drugId #{@request_data['priorRejoinDrugs']}."
            end
          end
        end
      end
    end
  end

  private :validate_patient_current_state, :validate_patient_rejoin_triggers, :validate_request_data

end