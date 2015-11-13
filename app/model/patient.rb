require 'mongoid'

class Patient
  include Mongoid::Document
  store_in collection: 'patient'

  def addPriorRejoinDrugs(drugs)
    # TODO: Add prior rejoin drugs to the current patient object.
  end

  def addRejoinPatientTrigger()
    self['currentPatientStatus'] = 'REJOIN'
    self['patientTriggers'].push(
        {
            studyId: 'EAY131',
            patientSequenceNumber: self['patientSequenceNumber'],
            stepNumber: self['currentStepNumber'],
            patientStatus: 'REJOIN',
            message: 'Notified by ECOG that the patient has rejoined the study.',
            dateCretaed: DateTime.now,
            auditDate: DateTime.now
        })
    self
  end
end
