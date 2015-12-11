module Sinatra
  module WorkflowApi
    module MDAMessagingService

      def self.registered(service)

        service.post '/assayMessage' do
          status 501
        end

        service.post '/setBiopsySpecimenDetails' do
          status 501
        end

        service.post '/setNucleicAcidsShippingDetails' do
          status 501
        end

      end

    end
  end
end