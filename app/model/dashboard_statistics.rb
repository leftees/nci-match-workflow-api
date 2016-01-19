class DashboardStatistics
  attr_reader :number_of_patients, :number_of_screened_patients, :number_of_patients_with_treatment,
              :number_of_pending_variant_reports, :number_of_pending_assignment_reports

  def initialize
    # TODO: Query the database for the information
    @number_of_patients = 768
    @number_of_screened_patients = 645
    @number_of_patients_with_treatment = 25
    @number_of_pending_variant_reports = 10
    @number_of_pending_assignment_reports = 5
  end

end