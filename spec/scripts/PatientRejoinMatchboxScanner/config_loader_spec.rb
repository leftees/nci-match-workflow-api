require 'yaml'

require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/config_loader"

RSpec.describe ConfigLoader, '#initialize' do
  context 'with invalid configuration path' do
    it 'should raise an exception' do
      expect { ConfigLoader.new('../config/dummy.yml', 'development') }.to raise_error(Errno::ENOENT)
    end
  end

  context 'with a valid configuration path' do
    it 'parses the configuration file successfully' do
      cl = ConfigLoader.new('../config/scanner.yml', 'development')
      parsed_config = cl.config

      expect(parsed_config['database']['hosts']).to eq(['127.0.0.1:27017'])
      expect(parsed_config['database']['dbname']).to eq('MatchTest')
      expect(parsed_config['database']['username']).to eq('MatchTest')
      expect(parsed_config['database']['password']).to eq('MatchTest')

      expect(parsed_config['match_api']['scheme']).to eq('http')
      expect(parsed_config['match_api']['hosts']).to eq(['127.0.0.1:8080'])
      expect(parsed_config['match_api']['context']).to eq('/match')

      expect(parsed_config['ecog_api']['scheme']).to eq('http')
      expect(parsed_config['ecog_api']['hosts']).to eq(['127.0.0.1:3000'])
      expect(parsed_config['ecog_api']['context']).to eq('/MatchInformaticsLayer')
    end
  end
end