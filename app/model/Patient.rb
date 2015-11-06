require 'mongoid'

class Patient
  include Mongoid::Document
  store_in collection: 'patient'
end