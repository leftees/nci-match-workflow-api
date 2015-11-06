require 'mongoid'

class PatientRejoinLog
  include Mongoid::Document
  store_in collection: 'patientRejoinLog'
end