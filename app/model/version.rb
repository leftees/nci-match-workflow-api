class Version
  include Singleton
  attr_reader :version

  def initialize
    @version = 'v.1.0.0-beta1'
  end
end