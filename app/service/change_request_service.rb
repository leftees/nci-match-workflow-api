module Sinatra
  module WorkflowApi
    module ChangeRequestService
      require 'sinatra/base'
      require "#{File.dirname(__FILE__)}/../util/filesystem_config"
      # require 'sinatra/config_file'
      # class ChangeRequest < Sinatra::Base
      def self.registered(service)

        baseChangeDirectory = FileSystemConfig.local_storage_path + '/change_request_files'

        service.post '/changerequest/:patientID' do
            # upload with:
            #curl -v -F "data=@/path/to/filename.ext"  http://localhost:9292/changerequest/PatientID
            datafile = params[:data]
            fullpath = "#{baseChangeDirectory}/#{params[:patientID]}/#{datafile[:filename]}"
            WorkflowLogger.logger.info "WORKFLOW API | Change Request, processing upload #{fullpath} ..."

            # check if file already exists
            if File.exist?(fullpath)
              WorkflowLogger.logger.info "WORKFLOW API | Change Request, ERROR File #{fullpath} already exists, 400"
              body TransactionMessage.new('FAILURE', "File #{params[:patientID]}/#{datafile[:filename]} already exists").to_json
              halt 400
            end

            # need to create directory if it doesn't exist
            dirname = File.dirname(fullpath)
            tokens = dirname.split(/[\/\\]/)
            if (tokens[0] == "" && !tokens[1].nil?) # Handle leading / or not
              tokens[1] = '/' + tokens[1]
              tokens.delete_at(0)
            end
            1.upto(tokens.size) do |n|
              dir = tokens[0...n]
              Dir.mkdir(dir.join("/")) unless Dir.exist?(dir.join("/"))
            end

            #write temp file to destination
            diskfile = File.new(fullpath, "w")
            # diskfile.write("Test file")
            datafile = params[:data]
            diskfile.write(datafile[:tempfile].read)
            diskfile.close
            WorkflowLogger.logger.info "WORKFLOW API | Change Request, file upload completed successfully"
            status 200
            return "The file was successfully uploaded!"
        end

        # service.get '/changerequest/info' do
        #   content_type :json
        #   version = Version.instance
        #   WorkflowLogger.logger.info "WORKFLOW API | Returning version '#{version.to_json}' to remote host."
        #   version.to_json
        # end

        service.get '/changerequest/:patientID' do
          content_type :json
          fullpath = "#{baseChangeDirectory}/#{params[:patientID]}"
          if File.exist?(fullpath)
            WorkflowLogger.logger.info "WORKFLOW API | Change Request, file list for patient returned successfully"
            filelist = Dir.glob("#{fullpath}/*")
            return filelist.to_json
          else
            WorkflowLogger.logger.info "WORKFLOW API | Change Request, ERROR Patient #{fullpath} does not exist, 404"
            status 404
            body TransactionMessage.new('FAILURE', "PatientID #{params[:patientID]} does not exist").to_json
          end
        end

        service.get '/changerequest/:patientID/:filename' do
          # content_type :json
          fullpath = "#{baseChangeDirectory}/#{params[:patientID]}/#{params[:filename]}"
          if File.exist?(fullpath)
            WorkflowLogger.logger.info "WORKFLOW API | Change Request, file for patient returned successfully"
            return send_file fullpath, :disposition => :attachment
          else
            WorkflowLogger.logger.info "WORKFLOW API | Change Request, ERROR Patient file #{fullpath} does not exist, 404"
            status 404
            body TransactionMessage.new('FAILURE', "Filename for that PatientID #{params[:patientID]}/#{params[:filename]} does not exist").to_json
          end
        end

      end
      # end

    end
  end
end
