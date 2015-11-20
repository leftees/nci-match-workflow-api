require "#{File.dirname(__FILE__)}/../spec_helper"
require "#{File.dirname(__FILE__)}/../../scripts/PatientRejoinMatchboxScanner/lib/ecog_api_client"

RSpec.describe EcogAPIClient, '#send_patient_eligible_for_rejoin' do
  before(:each) do
    @api_config = {
        'ecog_api' => {
            'scheme' => 'https',
            'hosts' => ['ecoghost:443'],
            'context' => '/MatchInformaticsLayer'
        }
    }
  end

  context 'with a bad input parameter' do
    it 'should raise an ArgumentError' do
      client = EcogAPIClient.new(@api_config)
      expect { client.send_patient_eligible_for_rejoin }.to raise_error(ArgumentError)
      expect { client.send_patient_eligible_for_rejoin(nil) }.to raise_error(ArgumentError)
      expect { client.send_patient_eligible_for_rejoin([]) }.to raise_error(ArgumentError)
      expect { client.send_patient_eligible_for_rejoin('') }.to raise_error(ArgumentError)
      expect { client.send_patient_eligible_for_rejoin(56) }.to raise_error(ArgumentError)
    end
  end

  context 'with a single patient sequence number' do
    it 'should receive a successful response' do
      stub_request(:post, 'https://ecoghost/MatchInformaticsLayer/services/rs/rerun').
          with(:body => "[\"12345\"]",
               :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'9', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '{ "status" : "SUCCESS", "message" : "This message have been recorded." }', :headers => {})

      client = EcogAPIClient.new(@api_config)
      response = client.send_patient_eligible_for_rejoin(['12345'])

      expect(response).to be_instance_of(String)
      expect(response.length).to be > 0
    end
  end

  context 'with a single patient sequence number but using default api config' do
    it 'should receive a successful response' do
      stub_request(:post, 'http://127.0.0.1:3000/MatchInformaticsLayer/services/rs/rerun').
          with(:body => "[\"12345\"]",
               :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'9', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '{ "status" : "SUCCESS", "message" : "This message have been recorded." }', :headers => {})

      client = EcogAPIClient.new({ 'ecog_api' => {} })
      response = client.send_patient_eligible_for_rejoin(['12345'])

      expect(response).to be_instance_of(String)
      expect(response.length).to be > 0
    end
  end

  context 'with a multiple patient sequence numbers' do
    it 'should receive a successful response' do
      stub_request(:post, 'https://ecoghost/MatchInformaticsLayer/services/rs/rerun').
          with(:body => "[\"123\",\"456\",\"789\"]",
               :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'19', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '{ "status" : "SUCCESS", "message" : "This message have been recorded." }', :headers => {})

      client = EcogAPIClient.new(@api_config)
      response = client.send_patient_eligible_for_rejoin(['123', '456', '789'])

      expect(response).to be_instance_of(String)
      expect(response.length).to be > 0
    end
  end

  context 'with a multiple patient sequence numbers when ECOG is down' do
    it 'should receive a internal server error' do
      stub_request(:post, 'https://ecoghost/MatchInformaticsLayer/services/rs/rerun').
          with(:body => "[\"123\",\"456\",\"789\"]",
               :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'19', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 500, :body => '', :headers => {})

      client = EcogAPIClient.new(@api_config)
      expect { client.send_patient_eligible_for_rejoin(['123', '456', '789']) }.to raise_error(RestClient::InternalServerError)
    end
  end

  context 'with a multiple patient sequence numbers to a non-existent endpoint' do
    it 'should receive a resource not found error' do
      stub_request(:post, 'https://ecoghost/MatchInformaticsLayer/services/rs/rerun').
          with(:body => "[\"123\",\"456\",\"789\"]",
               :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'19', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 404, :body => '', :headers => {})

      client = EcogAPIClient.new(@api_config)
      expect { client.send_patient_eligible_for_rejoin(['123', '456', '789']) }.to raise_error(RestClient::ResourceNotFound)
    end
  end

  context 'with a multiple patient sequence numbers with a bad request' do
    it 'should receive a bad request error' do
      stub_request(:post, 'https://ecoghost/MatchInformaticsLayer/services/rs/rerun').
          with(:body => "[\"123\",\"456\",\"789\"]",
               :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'19', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 400, :body => '', :headers => {})

      client = EcogAPIClient.new(@api_config)
      expect { client.send_patient_eligible_for_rejoin(['123', '456', '789']) }.to raise_error(RestClient::BadRequest)
    end
  end

end