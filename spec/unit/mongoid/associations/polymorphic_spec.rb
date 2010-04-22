require "spec_helper"

describe Mongoid::Associations::Options do
  
  describe "polymorphic association" do
    parent = ExampleWithPolymorphic.create
    other = ExampleWithPolymorphic.create
    other_type = OtherExampleWithPolymorphic.create
    
    parent.polymorphics.count.should == 0
    other.polymorphics.count.should == 0
    other_type.polymorphics.count.should == 0
    
    parent.polymorphics.create({})
    
    parent.polymorphics.count.should == 1
    other.polymorphics.count.should == 0
    other_type.polymorphics.count.should == 0
    
    parent.polymorphics.first.example.should == parent
    parent.polymorphics.first.example_type.should == parent.class.to_s
  end

end
