require File.dirname(__FILE__) + '/../../spec_helper'


describe "DemoApp" do
  before do
    browser.goto(DEMO_APP)
    @flex = browser.flex_app('DemoAppId', 'DemoAppName')
  end
  
  it "should click on a checkbox" do
    tree = @flex.objectTree
    tree.open('Button controls')
    tree.select('Button controls>CheckBox1')

    check_box = @flex.milkCB
    check_box.click

    message = @flex.cartItems
    message.text.strip.should == "milk"
  end
  
  it "should assert that it is checked" do
    tree = @flex.objectTree
    tree.open('Button controls')
    tree.select('Button controls>CheckBox1')

    check_box = @flex.milkCB
    
    check_box.selected? == false
    
    check_box.click
    
    check_box.selected? == true

        
  end
  
  it "should select multiple checkboxes" do
    tree = @flex.objectTree
    tree.open('Button controls')
    tree.select('Button controls>CheckBox1')

    check_box = @flex.milkCB
    check_box.click
    check_box = @flex.eggsCB
    check_box.click
    

    message = @flex.cartItems
    message.text.strip.should == "milk\reggs"
  end
  
  it "should check the label" do
    tree = @flex.objectTree
    tree.open('Button controls')
    tree.select('Button controls>CheckBox1')

    check_box = @flex.milkCB
    check_box.label.strip.should == "milk"
  end

end
