class WithAttrAccessible
  include Mongoid::Document
  
  field :accessible
  field :other
  
  attr_accessible :accessible
end