class EligiblePatientSelector
  def self.get_selected_arm(assignment_results)
    if !assignment_results.nil? && assignment_results.has_key?('results')
      assignment_results['results'].each do |arm_result|
        return arm_result if arm_result['reasonCategory'] == 'SELECTED'
      end
    end
    return nil
  end
end