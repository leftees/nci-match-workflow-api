class PatientAssignmentQueueMessage
  attr_reader :header, :data

  def initialize(patientSequenceNumber)
    @header = { 'type' => 'PATIENT_ASSIGNMENT', 'dateCreated' => DateTime.now.strftime('%Q') }
    @data = { 'patientSequenceNumber' =>  patientSequenceNumber }
  end
end