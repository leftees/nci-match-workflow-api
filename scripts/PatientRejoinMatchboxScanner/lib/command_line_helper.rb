require 'optparse'

class CommandLineHelper
  attr_reader :options

  def initialize
    get_options
  end

  def get_options
    @options = {}

    optparse = OptionParser.new do |opts|
      opts.banner = 'Usage: patient_rejoin_matchbox_scanner.rb [options]'

      opts.on('-c', '--configPath config_path', 'Path to the yaml configuration file.') do |configPath|
        options[:configPath] = configPath
      end

      opts.on('-e', '--environment environment', 'The mode to run the script.') do |environment|
        options[:environment] = environment
      end

      opts.on('-p', '--print', 'Print out a list of patient(s) eligible for rejoin.') do
        options[:print] = true
      end
    end

    begin
      optparse.parse! ARGV
    rescue OptionParser::InvalidOption => error
      p "Failed to parse command line options, received error: #{error.message}"
    end

    raise OptionParser::MissingArgument.new('Missing path to yaml configuration file argument.') if options[:configPath].nil?
  end

  private :get_options

end