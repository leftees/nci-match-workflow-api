require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/eligible_patient_selector"

RSpec.describe EligiblePatientSelector, '.get_selected_arm' do
  context 'with a nil value' do
    it 'should return a nil value' do
      expect(EligiblePatientSelector.get_selected_arm(nil)).to be_nil
    end
  end

  context 'without the results key in the associative array' do
    it 'should return a nil value' do
      expect(EligiblePatientSelector.get_selected_arm({ 'result' => [] })).to be_nil
    end
  end

  context 'with no arm selected for the patient' do
    it 'should return a nil value' do
      expect(EligiblePatientSelector.get_selected_arm({ 'results' => [ { 'reasonCategory' => 'NO_VARIANT_MATCH' }, { 'reasonCategory' => 'ARM_NOT_OPEN' } ] })).to be_nil
    end
  end

  context 'with an arm selected for the patient' do
    it 'should return the arm selected' do
      assignment_results = { 'results' => [ { 'treatmentArmId' => 'Arm1',  'reasonCategory' => 'NO_VARIANT_MATCH' }, { 'treatmentArmId' => 'Arm2', 'reasonCategory' => 'SELECTED' }, { 'treatmentArmId' => 'Arm3', 'reasonCategory' => 'ARM_NOT_OPEN' } ] }
      selected_arm = EligiblePatientSelector.get_selected_arm(assignment_results)
      expect(selected_arm['treatmentArmId']).to eq('Arm2')
    end
  end
end