require "#{File.dirname(__FILE__)}/../spec_helper"
require "#{File.dirname(__FILE__)}/../../scripts/PatientRejoinMatchboxScanner/lib/match_api_client"

RSpec.describe MatchAPIClient, '#simulate_patient_assignment' do
  before(:each) do
    @api_config = {
        'match_api' => {
            'scheme' => 'https',
            'hosts' => ['matchhost:443'],
            'context' => '/match'
        }
    }
  end

  context 'with a bad input parameters' do
    it 'should raise an ArgumentError' do
      client = MatchAPIClient.new(@api_config)
      expect { client.simulate_patient_assignment }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment(nil, nil) }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment('','') }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment('123', nil) }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment('123', []) }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment('123', {}) }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment(nil, '123') }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment([], '123') }.to raise_error(ArgumentError)
      expect { client.simulate_patient_assignment({}, '123') }.to raise_error(ArgumentError)
    end
  end

  context 'with valid patient sequence number and analysis id but using default api config' do
    it 'should receive a successful response' do
      stub_request(:get, 'http://127.0.0.1:8080/match/common/rs/simulateAssignmentByPatient?analysisId=job1&patientId=12345').
          with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '[{ "treatmentArmId" : "EAY131-Q", "treatmentArmVersionId" : "2015-08-06", "reason" : "The patient and treatment arm match on variant identifier [ERBB2]. The variant\'s level of evidence for the treatment arm is 1. The treatment arm\'s matching patient variant does not have a allele frequency. The treatment arm\'s current accrued number is 4. As a final tie breaker a randomizer was used to choose one treatment arm from a total of 3 and this one was selected.", "reasonCategory" : "SELECTED" }]', :headers => {})

      client = MatchAPIClient.new({ 'match_api' => {} })
      response = client.simulate_patient_assignment('12345', 'job1')

      expect(response).to be_instance_of(Array)
      expect(response.size).to be > 0
    end
  end

  context 'with valid patient sequence number and analysis id' do
    it 'should receive a successful response' do
      stub_request(:get, 'https://matchhost/match/common/rs/simulateAssignmentByPatient?analysisId=job1&patientId=12345').
          with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '[{ "treatmentArmId" : "EAY131-Q", "treatmentArmVersionId" : "2015-08-06", "reason" : "The patient and treatment arm match on variant identifier [ERBB2]. The variant\'s level of evidence for the treatment arm is 1. The treatment arm\'s matching patient variant does not have a allele frequency. The treatment arm\'s current accrued number is 4. As a final tie breaker a randomizer was used to choose one treatment arm from a total of 3 and this one was selected.", "reasonCategory" : "SELECTED" }]', :headers => {})

      client = MatchAPIClient.new(@api_config)
      response = client.simulate_patient_assignment('12345', 'job1')

      expect(response).to be_instance_of(Array)
      expect(response.size).to be > 0
    end
  end

  context 'with valid patient sequence number and analysis id but Matchbox is down' do
    it 'should receive a internal server error' do
      stub_request(:get, 'https://matchhost/match/common/rs/simulateAssignmentByPatient?analysisId=job1&patientId=12345').
          with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 500, :body => '', :headers => {})

      client = MatchAPIClient.new(@api_config)
      expect { client.simulate_patient_assignment('12345', 'job1') }.to raise_error(RestClient::InternalServerError)
    end
  end

  context 'with valid patient sequence number and analysis id but the endpoint does not exist' do
    it 'should receive a resource not found error' do
      stub_request(:get, 'https://matchhost/match/common/rs/simulateAssignmentByPatient?analysisId=job1&patientId=12345').
          with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 404, :body => '', :headers => {})

      client = MatchAPIClient.new(@api_config)
      expect { client.simulate_patient_assignment('12345', 'job1') }.to raise_error(RestClient::ResourceNotFound)
    end
  end

  context 'with valid patient sequence number and analysis id but the request bad' do
    it 'should receive a bad request error' do
      stub_request(:get, 'https://matchhost/match/common/rs/simulateAssignmentByPatient?analysisId=job1&patientId=12345').
          with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
          to_return(:status => 400, :body => '', :headers => {})

      client = MatchAPIClient.new(@api_config)
      expect { client.simulate_patient_assignment('12345', 'job1') }.to raise_error(RestClient::BadRequest)
    end
  end

end