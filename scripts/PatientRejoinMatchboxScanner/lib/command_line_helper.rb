require 'optparse'

class CommandLineHelper
  attr_reader :options

  def initialize
    get_options
  end

  def get_options
    @options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: patient_rejoin_matchbox_scanner.rb [options]'

      opts.on('-c', '--configPath config_path', 'Path to the database.yaml file.') do |configPath|
        options[:configPath] = configPath
      end

      opts.on('-m', '--mode mode', 'The mode to run the script.') do |mode|
        options[:mode] = mode
      end
    end.parse!
  end

  private :get_options

end