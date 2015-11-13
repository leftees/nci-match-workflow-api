require 'mongoid'

class Patient
  include Mongoid::Document
  store_in collection: 'patient'

  field :patientSequenceNumber, type: String
  field :currentPatientStatus, type: String
  field :currentStepNumber, type: String
  field :patientRejoinTriggers, type: Array
  field :patientTriggers, type: Array
  field :priorDrugs, type: Array

  def add_prior_drugs(priorDrugs)
    if !priorDrugs.nil? && priorDrugs.size > 0
      updated_prior_drugs = [] + self['priorDrugs']
      priorDrugs.each do |drugCombo|
        if !drugCombo['drugs'].nil? && drugCombo['drugs'].size > 0
          updated_prior_drugs.push(drugCombo)
        end
      end
      self['priorDrugs'] = updated_prior_drugs
    end
    self
  end

  def add_patient_trigger(status)
    self['currentPatientStatus'] = status
    self['patientTriggers'] += [{
            studyId: 'EAY131',
            patientSequenceNumber: self['patientSequenceNumber'],
            stepNumber: self['currentStepNumber'],
            patientStatus: status,
            message: 'Notified by ECOG that the patient has rejoined the study.',
            dateCretaed: DateTime.now,
            auditDate: DateTime.now
        }]
    self
  end

  def set_rejoin_date
    updated_rejoin_triggers = []
    rejoin_trigger = self['patientRejoinTriggers'][self['patientRejoinTriggers'].size - 1]
    rejoin_trigger['dateRejoined'] = DateTime.now
    updated_rejoin_triggers += self['patientRejoinTriggers']
    self['patientRejoinTriggers'] = updated_rejoin_triggers
    self
  end
end
