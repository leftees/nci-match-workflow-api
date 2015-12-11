module Sinatra
  module WorkflowApi
    module CLIAMessagingService

      def self.registered(service)

        service.post '/ionReporterUploadFileSet' do
          status 501
        end

        service.post '/irUploaderHeartBeat' do
          status 501
        end

        service.post '/loadPositiveControls' do
          status 501
        end

      end

    end
  end
end