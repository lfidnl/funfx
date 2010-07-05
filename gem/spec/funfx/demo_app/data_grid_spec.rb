require File.dirname(__FILE__) + '/../../spec_helper'

describe "DataGrid" do
  before do
    browser.goto(DEMO_APP)
    @flex = browser.flex_app('DemoAppId', 'DemoAppName')
	
    tree = @flex.objectTree
    tree.open('General controls')
    tree.select('General controls>DataGrid1')

    @data_grid = @flex.dg
  end

  it "should get columnnames from a datagrid" do
    pending "Find out why invisible columns is shown" do
      @data_grid.column_names.should == ['name', 'phone', 'email']
    end
  end
  
  it "should get data from a datagrid" do
    pending "Find out why invisible columns is shown" do
      @data_grid.values(0,3).should == [
        ["Christina Coenraets", "555-219-2270", "ccoenraets@fictitious.com"],
        ["Joanne Wall",         "555-219-2012", "jwall@fictitious.com"     ], 
        ["Maurice Smith",       "555-219-2012", "maurice@fictitious.com"   ],
        ["Mary Jones",          "555-219-2000", "mjones@fictitious.com"    ]
      ]
    end
  end

  it "should get num_columns from a datagrid" do
    pending "Find out why invisible columns is shown" do
      @data_grid.num_columns.should == 3
    end
  end

  it "should get num_rows from a datagrid" do
    @data_grid.num_rows.should == 4
  end
  
  it "should select row" do
    @data_grid.select("*Joanne Wall* | 555-219-2012 | jwall@fictitious.com")
    
    @data_grid.selectedIndex.should == 1
  end
  
  it "should deselect row" do
    @data_grid.select("*Joanne Wall* | 555-219-2012 | jwall@fictitious.com")
    @data_grid.deselect("*Joanne Wall* | 555-219-2012 | jwall@fictitious.com")
  end
  
  it "should drag and drop" do
    pending "Find out why invisible columns is shown" do
      @data_grid.drag_start("*Joanne Wall* | 555-219-2012 | jwall@fictitious.com")
      
      data_grid_drop = @flex.data_grid({:id => 'dgDrop'})
      data_grid_drop.drag_drop('copy')
      
      data_grid_drop.values(0,0).should == [
        ["Joanne Wall",         "555-219-2012", "jwall@fictitious.com"]
      ]
    end
  end
end
