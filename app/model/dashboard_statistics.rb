class DashboardStatistics
  attr_reader :number_of_patients, :number_of_screened_patients, :number_of_patients_with_treatment,
              :number_of_pending_variant_reports, :number_of_pending_assignment_reports

  def initialize
    @number_of_patients = Patient.count
    @number_of_screened_patients = Patient.where('biopsies.nextGenerationSequences.status' => 'CONFIRMED').count
    @number_of_patients_with_treatment = Patient.where(:currentPatientStatus => 'ON_TREATMENT_ARM').count
    @number_of_pending_variant_reports = Patient.where('biopsies.nextGenerationSequences.status' => 'PENDING').count
    @number_of_pending_assignment_reports = Patient.where(:currentPatientStatus => 'PENDING_CONFIRMATION').count
  end

end