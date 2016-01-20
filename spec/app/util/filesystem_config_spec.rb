require "#{File.dirname(__FILE__)}/../../../app/util/filesystem_config"

RSpec.describe FileSystemConfig, '.load' do
  context 'a FileSystemConfig yml file that does not exist' do
    it 'should uses the default values' do
      FileSystemConfig.load!('/tmp/workflow-api/config/FileSystemConfig-doesntexist.yml','development')

      expect(FileSystemConfig.local_storage_path).to eq('changerequest')
    end
  end

  context 'a FileSystemConfig yml file but environment does not exist' do
    it 'should uses the default values' do
      FileSystemConfig.load!('spec/resource/filesystem_config-unittest.yml','no_such_env')
      expect(FileSystemConfig.local_storage_path).to eq('changerequest')
    end
  end

  context 'a FileSystemConfig yml file that exist' do
    it 'should store the values from the yml file' do
      FileSystemConfig.load!('spec/resource/filesystem-config-unittest.yml','unittest')

      expect(FileSystemConfig.local_storage_path).to eq('testdir')
    end
  end
end