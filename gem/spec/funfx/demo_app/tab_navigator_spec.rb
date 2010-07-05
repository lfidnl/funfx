require File.dirname(__FILE__) + '/../../spec_helper'

describe "DemoApp" do
  before do
    browser.goto(DEMO_APP)
    @flex = browser.flex_app('DemoAppId', 'DemoAppName')
  end
  
  it "should switch tab in a tab navigator" do
    tree = @flex.objectTree
    tree.open('Container controls')
    tree.select('Container controls>TabNavigator1')
  
    tab_navigator = @flex.tabNav
    tab_navigator.selectedIndex.should == 0
    tab_navigator.change("View 2: Sales Trends Chart")
    tab_navigator.selectedIndex.should == 1
  end
end
