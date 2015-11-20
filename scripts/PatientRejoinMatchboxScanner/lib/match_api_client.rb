require 'rest-client'

class MatchAPIClient

  def initialize(api_config)
    @defaults = { :scheme => 'http', :hosts => ['127.0.0.1:8080'], :context => '/match' }

    @scheme = get_prop(api_config, 'scheme')
    @hosts = get_prop(api_config, 'hosts')
    @context = get_prop(api_config, 'context')
  end

  def simulate_patient_assignment(patient_sequence_number, analysis_id)
    if (patient_sequence_number.nil? || !patient_sequence_number.kind_of?(String) || patient_sequence_number.empty?) || (analysis_id.nil? || !analysis_id.kind_of?(String) || analysis_id.empty?)
      raise ArgumentError, 'Patient sequence number and analysis id cannot be nil or empty.'
    end
    url = build_match_context_url + "/common/rs/simulateAssignmentByPatient?patientId=#{patient_sequence_number}&analysisId=#{analysis_id}"
    JSON.parse(RestClient.get url, {:accept => :json})
  end

  def get_prop(api_config, key)
    if !api_config.nil? && api_config.has_key?('match_api') && api_config['match_api'].has_key?(key)
      return api_config['match_api'][key]
    end
    return @defaults.has_key?(key.to_sym) ? @defaults[key.to_sym] : nil
  end

  def build_match_context_url
    return "#{@scheme}://#{@hosts[0]}#{@context}"
  end

  private :get_prop, :build_match_context_url

end