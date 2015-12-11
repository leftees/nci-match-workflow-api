module Sinatra
  module WorkflowApi
    module MatchService

      def self.registered(service)

        service.get '/version' do
          content_type :json
          version = Version.instance
          WorkflowLogger.logger.info "WORKFLOW API | Returning version '#{version.to_json}' to remote host."
          version.to_json
        end

      end

    end
  end
end
