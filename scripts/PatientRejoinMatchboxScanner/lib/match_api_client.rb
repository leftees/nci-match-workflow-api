require 'rest-client'

class MatchAPIClient

  def initialize(api_config)
    @defaults = { :scheme => 'http', :hosts => ['127.0.0.1:8080'], :context => '/match' }

    @scheme = get_prop(api_config, 'scheme')
    @hosts = get_prop(api_config, 'hosts')
    @context = get_prop(api_config, 'context')
  end

  def simulate_patient_assignment(patient_sequence_number, analysis_id)
    url = build_match_context_url + "/common/rs/simulateAssignmentByPatient?patientId=#{patient_sequence_number}&analysisId=#{analysis_id}"
    JSON.parse(RestClient.get url, {:accept => :json})
  end

  def get_prop(db_config, key)
    if !db_config.nil? && db_config.has_key?('match_api') && db_config['match_api'].has_key?(key)
      return db_config['match_api'][key]
    end
    return @defaults.has_key?(key.to_s) ? @defaults[key.to_s] : nil
  end

  def build_match_context_url
    return "#{@scheme}://#{@hosts[0]}#{@context}"
  end

  private :get_prop, :build_match_context_url

end