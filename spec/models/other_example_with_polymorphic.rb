class OtherExampleWithPolymorphic
  include Mongoid::Document
  
  has_many_related :polymorphics, :as => :example
end
