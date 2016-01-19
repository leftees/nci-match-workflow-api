class FileSystemConfig
  @@local_storage_path = 'changerequest'

  def self.load!(ymlPath, env)
    @@filesystem_config = YAML.load_file(ymlPath)[env.to_s] rescue nil

    @@local_storage_path = @@filesystem_config['local_storage_path'] rescue  'changerequest'
  end

  def self.local_storage_path
    @@local_storage_path
  end


end