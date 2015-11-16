require 'rest-client'

class EcogAPIClient

  def initialize(api_config)
    @defaults = { :scheme => 'http', :hosts => ['127.0.0.1:8080'], :context => '/MatchInformaticsLayer' }

    @scheme = get_prop(api_config, 'scheme')
    @hosts = get_prop(api_config, 'hosts')
    @context = get_prop(api_config, 'context')
  end

  def send_patient_eligible_for_rejoin(patientSequenceNumbers)
    url = build_ecog_context_url + '/services/rs/rerun'
    RestClient.post url, patientSequenceNumbers.to_json, :content_type => :json, :accept => :json
  end

  def get_prop(db_config, key)
    if !db_config.nil? && db_config.has_key?('ecog_api') && db_config['ecog_api'].has_key?(key)
      return db_config['ecog_api'][key]
    end
    return @defaults.has_key?(key.to_s) ? @defaults[key.to_s] : nil
  end

  def build_ecog_context_url
    return "#{@scheme}://#{@hosts[0]}#{@context}"
  end

  private :get_prop, :build_ecog_context_url

end