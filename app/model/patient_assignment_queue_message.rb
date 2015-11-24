class PatientAssignmentQueueMessage
  attr_reader :header, :data

  def initialize(patientSequenceNumber)
    @header = { 'type' => 'PATIENT_ASSIGNMENT', 'dateCreated' => DateTime.now }
    @data = { 'patientSequenceNumber' =>  patientSequenceNumber }
  end
end