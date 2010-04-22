class Polymorphic
  include Mongoid::Document
  
  belongs_to_related :example, :polymorphic=>true
end
