module Sinatra
  module WorkflowApi
    module ChangeRequestService
      require 'sinatra/base'
      # class ChangeRequest < Sinatra::Base
      def self.registered(service)

        baseDirectory = "changerequest"

        service.post '/changerequest/:patientID' do
            # upload with:
            #curl -v -F "data=@/path/to/filename.ext"  http://localhost:9292/changerequest/PatientID

            datafile = params[:data]
            fullpath = "#{baseDirectory}/#{params[:patientID]}/#{datafile[:filename]}"

            # check if file already exists
            #TODO

            # need to create directory if it doesn't exist
            dirname = File.dirname(fullpath)
            tokens = dirname.split(/[\/\\]/)
            1.upto(tokens.size) do |n|
              dir = tokens[0...n]
              puts "Dir=#{dir}"
              Dir.mkdir(dir.join("/")) unless Dir.exist?(dir.join("/"))
            end


            #write temp file to destination
            diskfile = File.new(fullpath, "w")
            # diskfile.write("Test file")
            datafile = params[:data]
            diskfile.write(datafile[:tempfile].read)
            diskfile.close
            return "The file was successfully uploaded!"
        end

        service.get '/changerequest/info' do
          content_type :json
          version = Version.instance
          WorkflowLogger.logger.info "WORKFLOW API | Returning version '#{version.to_json}' to remote host."
          version.to_json
        end

        service.get '/changerequest/:patientID' do
          content_type :json
          filelist = Dir.glob("#{baseDirectory}/#{params[:patientID]}/*")
          filelist.to_json
        end

        service.get '/changerequest/:patientID/:filename' do
          # content_type :json
          fullpath = "#{baseDirectory}/#{params[:patientID]}/#{params[:filename]}"
          if File.exist?(fullpath)
            return send_file fullpath, :disposition => :attachment
          else
            status 404
          end
        end

      end
      # end

    end
  end
end
