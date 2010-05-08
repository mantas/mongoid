require "spec_helper"

describe "attr_accessible" do
  it "should save accessible attribute only" do
    obj1 = WithAttrAccessible.create(:accessible => "123", :other => "256")
    
    obj1.accessible.should == "123"
    obj1.other.should_not == "256"
    obj1.save.should == true
    
    obj1.reload
    obj1.accessible.should == "123"
    obj1.other.should_not == "256"
    
    obj1.update_attributes(:accessible => "321", :other =>"654")
    obj1.accessible.should == "321"
    obj1.other.should_not == "654"
    
    obj1.reload
    
    obj1.accessible.should == "321"
    obj1.other.should_not == "654"
  end
  
  it "should allow to set inaccessible attributes directly" do
    obj1 = WithAttrAccessible.new
    
    obj1.accessible = "123"
    obj1.accessible.should == "123"
    
    obj1.other = "256"
    obj1.other.should == "256"
    
    obj1.save
    
    obj1.reload
    
    obj1.accessible.should == "123"
    obj1.other.should == "256"
  end
end