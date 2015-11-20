require 'rest-client'

class EcogAPIClient

  def initialize(api_config)
    @defaults = { :scheme => 'http', :hosts => ['127.0.0.1:3000'], :context => '/MatchInformaticsLayer' }

    @scheme = get_prop(api_config, 'scheme')
    @hosts = get_prop(api_config, 'hosts')
    @context = get_prop(api_config, 'context')
  end

  def send_patient_eligible_for_rejoin(patientSequenceNumbers)
    if patientSequenceNumbers.nil? || !patientSequenceNumbers.kind_of?(Array) || patientSequenceNumbers.size == 0
      raise ArgumentError, 'Patient sequence number list cannot be nil or empty.'
    end

    url = build_ecog_context_url + '/services/rs/rerun'
    RestClient.post url, patientSequenceNumbers.to_json, :content_type => :json, :accept => :json
  end

  def get_prop(api_config, key)
    if !api_config.nil? && api_config.has_key?('ecog_api') && api_config['ecog_api'].has_key?(key)
      return api_config['ecog_api'][key]
    end
    return @defaults.has_key?(key.to_sym) ? @defaults[key.to_sym] : nil
  end

  def build_ecog_context_url
    return "#{@scheme}://#{@hosts[0]}#{@context}"
  end

  private :get_prop, :build_ecog_context_url

end