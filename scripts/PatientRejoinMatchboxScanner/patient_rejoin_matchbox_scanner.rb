require 'logger'

require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/config_loader"
require "#{File.dirname(__FILE__)}/lib/patient_dao"
require "#{File.dirname(__FILE__)}/lib/match_api_client"
require "#{File.dirname(__FILE__)}/lib/ecog_api_client"

logger = Logger.new(STDOUT)
logger.info('========== Starting Patient Rejoin Matchbox Scanner ==========')

begin
  clh = CommandLineHelper.new
  # TODO: Check that the required parameters are passed in else display the usage statement

  logger.info("SCANNER | Command line options received #{clh.options}")

  cl = ConfigLoader.new(clh.options[:configPath], clh.options[:environment])
  logger.debug("SCANNER | Database configuration #{cl.config['database']}")
  logger.debug("SCANNER | Match API configuration #{cl.config['match_api']}")
  logger.debug("SCANNER | ECOG API configuration #{cl.config['ecog_api']}")

  dao = PatientDao.new(cl.config)
  off_trial_patients = dao.get_patient_by_status('OFF_TRIAL_NO_TA_AVAILABLE')

  logger.info("SCANNER | Patients who are off trial without a treatment arm assignment #{off_trial_patients}.")

  match_api = MatchAPIClient.new(cl.config)

  eligible_patients = []
  off_trial_patients.each do |off_trial_patient|
    begin
      logger.info("SCANNER | Simulating assignment for patient #{off_trial_patient} ...")
      assignment_results = match_api.simulate_patient_assignment(off_trial_patient[:patient_sequence_number], off_trial_patient[:anaylsis_id])
      # TODO: If we find an arm that the patient is eligible than we add it to the array
      p assignment_results
    rescue => e
      logger.error("SCANNER | Failed to simulate assignment for patient #{off_trial_patient}. Message: '#{e}'")
    end
  end

  if eligible_patients.size > 0
    logger.info('SCANNER | Sending ECOG a list of patients eligible to rejoin Matchbox ...')
    ecog_api = EcogAPIClient.new(cl.config)
    ecog_api.send_patient_eligible_for_rejoin(eligible_patients)
    logger.info("SCANNER | Sending ECOG a list of patients eligible #{eligible_patients} to rejoin Matchbox complete.")
  else
    logger.info('SCANNER | No patients were found to be eligible to rejoin Matchbox.')
  end
rescue => e
  logger.error("SCANNER | Failed to complete scan because an exception was thrown. Message: '#{e}'")
end

logger.info('========== Patient Rejoin Matchbox Scanner Complete ==========')