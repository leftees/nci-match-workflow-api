require 'logger'

require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/config_loader"
require "#{File.dirname(__FILE__)}/lib/match_api_client"

clh = CommandLineHelper.new
cl = ConfigLoader.new(clh.options[:configPath], clh.options[:mode])

client = MatchAPIClient.new(cl)

documents = client.get_patient_by_status('OFF_TRIAL_NO_TA_AVAILABLE')
documents.each do |document|
  puts document
end