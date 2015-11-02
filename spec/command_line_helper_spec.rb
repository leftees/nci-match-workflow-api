require "#{File.dirname(__FILE__)}/../scripts/PatientRejoinMatchboxScanner/lib/command_line_helper"

RSpec.describe CommandLineHelper, '#get_options' do
  context 'with no command line options' do
    it 'should raise and exception' do
      expect { CommandLineHelper.new }.to raise_error(OptionParser::MissingArgument)
    end
  end

  context 'with no missing command line options' do
    it 'should return back the config path and mode' do
      ARGV.unshift('production')
      ARGV.unshift('-e')
      ARGV.unshift('../config/scanner.yml')
      ARGV.unshift('-c')

      clh = CommandLineHelper.new

      expect(clh.options[:configPath]).to eq('../config/scanner.yml')
      expect(clh.options[:environment]).to eq('production')
    end
  end
end