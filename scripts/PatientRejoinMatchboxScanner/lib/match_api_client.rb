require 'mongo'

class MatchAPIClient

  def initialize(db_config)
    @client = Mongo::Client.new([ db_config.hostname + ':' + db_config.port.to_s ], :database => db_config.dbname)
  end

  def get_patient_by_status(currentPatientStatus)
    @client[:patient].find(:currentPatientStatus => 'OFF_TRIAL_NO_TA_AVAILABLE')
  end

end