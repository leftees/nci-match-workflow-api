require 'mongo'

class PatientRejoinLogDao

  def initialize(db_config)
    @defaults = { :hosts => ['127.0.0.1:27017'], :dbname => 'match' }

    @hosts = get_prop(db_config, 'hosts')
    @port = get_prop(db_config, 'port')
    @dbname = get_prop(db_config, 'dbname')
    @username = get_prop(db_config, 'username')
    @password = get_prop(db_config, 'password')

    @client = Mongo::Client.new(@hosts, :database => @dbname, :user => @username, :password => @password)
  end

  def get_patient(patientSequenceNumber)

  end

  def add_rejoin_entry(patient)

  end

end