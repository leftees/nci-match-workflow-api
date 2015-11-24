require "#{File.dirname(__FILE__)}/../../../app/validator/rejoin_matchbox_validator"

RSpec.describe RejoinMatchboxValidator, '#validate' do
  context 'with a nil patient' do
    it 'should raise a rejoin error' do
      validator1 = RejoinMatchboxValidator.new(nil, nil)
      validator2 = RejoinMatchboxValidator.new(nil, {})

      expect{ validator1.validate }.to raise_error('Patient does not exist in Matchbox.')
      expect{ validator2.validate }.to raise_error('Patient does not exist in Matchbox.')
    end
  end

  context 'with no current patient status and step number' do
    it 'should raise a rejoin error' do
      validator = RejoinMatchboxValidator.new({ 'patientSequenceNumber' => '1234' }, nil)
      expect{ validator.validate }.to raise_error('Patient 1234 current status and/or step number is nil.')
    end
  end

  context 'with current patient status that is not "OFF_TRIAL_NO_TA_AVAILABLE" and step number 0' do
    it 'should raise a rejoin error' do
      statues = %w(REGISTRATION ON_TREATMENT_ARM OFF_TRIAL OFF_TRIAL_DECEASED OFF_TRIAL_NOT_CONSENTED OFF_TRIAL_REGISTRATION_ERROR)

      for status in statues
        validator = RejoinMatchboxValidator.new({ 'patientSequenceNumber' => '1234', 'currentPatientStatus' => status, 'currentStepNumber' => '0' }, nil)
        expect{ validator.validate }.to raise_error("Patient 1234 current status is #{status} and step number is 0.")
      end
    end
  end

  context 'with current patient status "OFF_TRIAL_NO_TA_AVAILABLE" and not on step number 0' do
    it 'should raise a rejoin error' do
      for step in 1..7
        validator = RejoinMatchboxValidator.new({ 'patientSequenceNumber' => '1234', 'currentPatientStatus' => 'OFF_TRIAL_NO_TA_AVAILABLE', 'currentStepNumber' => step.to_s }, nil)
        expect{ validator.validate }.to raise_error("Patient 1234 current status is OFF_TRIAL_NO_TA_AVAILABLE and step number is #{step}.")
      end
    end
  end

  context 'with no patient rejoin trigger' do
    it 'should raise a rejoin error' do
      validator = RejoinMatchboxValidator.new({ 'patientSequenceNumber' => '1234', 'currentPatientStatus' => 'OFF_TRIAL_NO_TA_AVAILABLE', 'currentStepNumber' => '0' }, nil)
      expect{ validator.validate }.to raise_error('No rejoin trigger exist for patient 1234.')
    end
  end

end