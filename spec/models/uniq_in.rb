class UniqIn
  include Mongoid::Document
  
  field :ext_unique
  
  validates_uniqueness_of :ext_unique, :in => "UniqExternal", :field => "unique"
end