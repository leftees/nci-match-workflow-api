class PatientAssignmentQueueMessage
  def initialize(patientSequenceNumber)
    @header = { 'type' => 'PATIENT_ASSIGNMENT', 'dateCreated' => DateTime.now }
    @data = { 'patientSequenceNumber' =>  patientSequenceNumber }
  end
end