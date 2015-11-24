require "#{File.dirname(__FILE__)}/../../../app/model/patient_assignment_queue_message"

RSpec.describe PatientAssignmentQueueMessage, '#initialize' do
  context 'with patient sequence number 12345' do
    it 'should return a message with a patient assignment type header and data element contains the patient sequence number ' do
      message = PatientAssignmentQueueMessage.new('12345')
      expect(message.header['type']).to eq('PATIENT_ASSIGNMENT')
      expect(message.header['dateCreated']).not_to be_nil
      expect(message.data['patientSequenceNumber']).to eq('12345')
    end
  end
end