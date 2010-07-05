require File.dirname(__FILE__) + '/../../spec_helper'

describe "EditableDataGrid" do
  before do
    browser.goto(DEMO_APP)
    @flex = browser.flex_app('DemoAppId', 'DemoAppName')
	
    tree = @flex.objectTree
    tree.open('General controls')
    tree.select('General controls>EditableDataGrid1')

    @data_grid = @flex.dgEditable
  end

  it "should edit a cell in the datagrid by using automationIndex" do
    @data_grid.values(0,3).should == [
      ["Christina Coenraets", "555-219-2270", "ccoenraets@fictitious.com", "true" ],
      ["Joanne Wall",         "555-219-2012", "jwall@fictitious.com"     , "true" ], 
      ["Maurice Smith",       "555-219-2012", "maurice@fictitious.com"   , "false"],
      ["Mary Jones",          "555-219-2000", "mjones@fictitious.com"    , "true" ]
    ]
    
    @data_grid.select("*Joanne Wall* | 555-219-2012 | jwall@fictitious.com | true")
    (@data_grid > {:automationIndex => 'name:1'}).input('Peter')
    @data_grid.select("Peter | *555-219-2012* | jwall@fictitious.com | true")
    (@data_grid > {:automationIndex => 'phone:1'}).input('7777')
    @flex.dgPanel.click
    
    @data_grid.values(0,3).should == [
      ["Christina Coenraets", "555-219-2270", "ccoenraets@fictitious.com", "true" ],
      ["Peter",               "7777", "jwall@fictitious.com"     , "true" ], 
      ["Maurice Smith",       "555-219-2012", "maurice@fictitious.com"   , "false"],
      ["Mary Jones",          "555-219-2000", "mjones@fictitious.com"    , "true" ]
    ]
  end
  
  it "should edit a cell with itemrenderer in the datagrid by using automationIndex" do
    @data_grid.values(0,3).should == [
      ["Christina Coenraets", "555-219-2270", "ccoenraets@fictitious.com", "true" ],
      ["Joanne Wall",         "555-219-2012", "jwall@fictitious.com"     , "true" ], 
      ["Maurice Smith",       "555-219-2012", "maurice@fictitious.com"   , "false"],
      ["Mary Jones",          "555-219-2000", "mjones@fictitious.com"    , "true" ]
    ]
    
    @data_grid.select("Joanne Wall | 555-219-2012 | jwall@fictitious.com | *true*")
    (@data_grid > {:automationIndex => 'active:1'}).open
    (@data_grid > {:automationIndex => 'active:1'}).select('false')
    @flex.dgPanel.click
    
    @data_grid.values(0,3).should == [
      ["Christina Coenraets", "555-219-2270", "ccoenraets@fictitious.com", "true" ],
      ["Joanne Wall",         "555-219-2012", "jwall@fictitious.com"     , "false"], 
      ["Maurice Smith",       "555-219-2012", "maurice@fictitious.com"   , "false"],
      ["Mary Jones",          "555-219-2000", "mjones@fictitious.com"    , "true" ]
    ]
  end
  
  it "should edit a cell in the datagrid by using automationValue" do
    @data_grid.values(0,3).should == [
      ["Christina Coenraets", "555-219-2270", "ccoenraets@fictitious.com", "true" ],
      ["Joanne Wall",         "555-219-2012", "jwall@fictitious.com"     , "true" ], 
      ["Maurice Smith",       "555-219-2012", "maurice@fictitious.com"   , "false"],
      ["Mary Jones",          "555-219-2000", "mjones@fictitious.com"    , "true" ]
    ]
    
    @data_grid.select("*Joanne Wall* | 555-219-2012 | jwall@fictitious.com | true")
    (@data_grid > {:automationValue => 'Joanne Wall'}).input('Peter')
    @flex.dgPanel.click
    
    @data_grid.values(0,3).should == [
      ["Christina Coenraets", "555-219-2270", "ccoenraets@fictitious.com", "true" ],
      ["Peter",               "555-219-2012", "jwall@fictitious.com"     , "true" ], 
      ["Maurice Smith",       "555-219-2012", "maurice@fictitious.com"   , "false"],
      ["Mary Jones",          "555-219-2000", "mjones@fictitious.com"    , "true" ]
    ] 
  end
  
end
