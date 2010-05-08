require "spec_helper"

describe "attr_protected" do
  it "should not save protected attribute" do
    obj1 = WithAttrProtected.create(:protected => "123", :other => "256")
    
    obj1.protected.should_not == "123"
    obj1.other.should == "256"
    obj1.save.should == true
    
    obj1.reload
    obj1.protected.should_not == "123"
    obj1.other.should == "256"
    
    obj1.update_attributes(:protected => "321", :other =>"654")
    obj1.protected.should_not == "321"
    obj1.other.should == "654"
    
    obj1.reload
    
    obj1.protected.should_not == "321"
    obj1.other.should == "654"
  end
  
  it "should allow to set protected attributes directly" do
    obj1 = WithAttrProtected.new
    
    obj1.protected = "123"
    obj1.protected.should == "123"
    
    obj1.other = "256"
    obj1.other.should == "256"
    
    obj1.save
    
    obj1.reload
    
    obj1.protected.should == "123"
    obj1.other.should == "256"
  end
end