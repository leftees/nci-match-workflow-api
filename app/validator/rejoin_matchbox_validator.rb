require "#{File.dirname(__FILE__)}/../error/rejoin_error"

class RejoinMatchboxValidator
  def initialize(patient, request_data)
    @patient = patient
    @request_data = request_data
  end

  def validate
    if @patient.nil?
      raise RejoinError, 'Patient does not exist in Matchbox.'
    end

    patientSequenceNumber = @patient['patientSequenceNumber']
    currentPatientStatus = @patient['currentPatientStatus']
    currentStepNumber = @patient['currentStepNumber']

    if currentPatientStatus != 'OFF_TRIAL_NO_TA_AVAILABLE' || currentStepNumber != '0'
      raise RejoinError, "Patient #{patientSequenceNumber} current status is #{currentPatientStatus} and step number is #{currentStepNumber}."
    end

    if @patient['patientRejoinTriggers'].nil? || @patient['patientRejoinTriggers'].size == 0
      raise RejoinError, "No rejoin trigger exist for patient #{patientSequenceNumber}."
    end

    rejoin_trigger = @patient['patientRejoinTriggers'][@patient['patientRejoinTriggers'].size - 1]
    if !rejoin_trigger['dateRejoined'].nil?
      raise RejoinError, "Latest patient #{patientSequenceNumber} rejoin trigger has already been proceed, no pending rejoin trigger exist."
    end

    if !@request_data.nil? && !@request_data['priorRejoinDrugs'].nil? && @request_data['priorRejoinDrugs'].size > 0
      @request_data['priorRejoinDrugs'].each do |drugCombo|
        if drugCombo['drugs'].nil? || drugCombo['drugs'].empty?
          drugCombo['drugs'].each do |drug|
            if drug['drugId'].nil? || drug['drugId'].empty?
              raise RejoinError, "Rejoin request for patient #{patientSequenceNumber} contains a prior drug that is missing drugId #{priorRejoinDrug}."
            end
          end
        end
      end
    end
  end
end