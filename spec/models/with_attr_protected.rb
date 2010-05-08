class WithAttrProtected
  include Mongoid::Document
  
  field :protected
  field :other
  
  attr_protected :protected
end