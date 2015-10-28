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

      opts.on('-m', '--mode mode', 'The mode to run the script.') do |mode|
        options[:mode] = mode
      end
    end
    optparse.parse!

    raise OptionParser::MissingArgument.new('Missing path to yaml configuration file argument.') if options[:configPath].nil?
  end

  private :get_options

end