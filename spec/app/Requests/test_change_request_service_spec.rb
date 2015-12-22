# require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../app/service/change_request_service"
require "#{File.dirname(__FILE__)}/../../spec_helper"
require 'rack/test'
require 'sinatra'

# describe 'Change Request Service Tests' do
RSpec.describe Sinatra::WorkflowApi::ChangeRequestService::ChangeRequest do
  def app
    Sinatra::WorkflowApi::ChangeRequestService::ChangeRequest
    # Sinatra::WorkflowApi::ChangeRequestService
  end

  # describe 'Get version info' do
  #   it 'should pass, returns version' do
  #     get '/changerequest/info'
  #     expect(last_response.status).to eq 200
  #   end
  # end

end
