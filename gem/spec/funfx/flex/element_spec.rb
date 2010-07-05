require File.dirname(__FILE__) + '/../../spec_helper'

module FunFX
  module Flex
    describe Element do
      
      describe "propery name rewriting" do
        before do
          @flex_app = mock('FlexApp')
          @element = Element.new(@flex_app, nil, {:id => 'box'})
        end
        
        it "should rewrite the property name to camel case" do
          Element.should_receive(:new).with(@flex_app, {:parent => nil, :id => 'box'}, {:id => 'camelCase'})
        
          @element.camel_case
        end
      
        it "should rewrite the property name to camel case when it ends with ?" do
          @flex_app.should_receive(:get_property_value).
            with("{parent: null, id: {id: 'box'}}", 'camelCase').
            and_return('true')
        
          @element.camel_case?
        end
        
        it "should send a camel case property name unchanged" do
          Element.should_receive(:new).with(@flex_app, {:parent => nil, :id => 'box'}, {:id => 'camelCase'})
        
          @element.camelCase
        end
        
        it "should strip ? off a camel case property" do
          @flex_app.should_receive(:get_property_value).
            with("{parent: null, id: {id: 'box'}}", 'camelCase').
            and_return('true')
        
          @element.camelCase?
        end
      end
      
      describe '#get_property_value' do
        it "should convert array of id hashes to flex automation id" do
          flex_app = mock('FlexApp')
          element = Element.new(flex_app, nil, {:id => 'box'})
        
          flex_app.should_receive(:get_property_value).
            with("{parent: null, id: {id: 'box'}}", 'WhatEver').
            and_return('true')
        
          element.get_property_value('WhatEver', TrueClass).should be_true
        end
        
        it "should convert array of id hashes with multiple definitions per object to flex automation id" do
          flex_app = mock('FlexApp')
          element = Element.new(flex_app, nil, {:id => 'box'})
        
          flex_app.should_receive(:get_property_value).
            with("{parent: null, id: {id: 'box'}}", 'WhatEver').
            and_return('true')
        
          element.get_property_value('WhatEver', TrueClass).should be_true
        end
        
        it "should sort a single hash and pass it through to flex as is" do
          flex_app = mock('FlexApp')
          element = Element.new(flex_app, nil, {:id => 'box', :automationName => 'Button Control Example', :text => 'Arbitrary Text'})
        
          flex_app.should_receive(:get_property_value).
            with("{parent: null, id: {automationName: 'Button%20Control%20Example', id: 'box', text: 'Arbitrary%20Text'}}", 'WhatEver').
            and_return('true')
        
          element.get_property_value('WhatEver', TrueClass).should be_true
        end
        
        it "should be able to use a parent object" do
          flex_app = mock('FlexApp')

          parent = Element.new(flex_app, nil, {:id => 'parent'})
          child = parent.child
          
          flex_app.should_receive(:get_property_value).
            with("{parent: {parent: null, id: {id: 'parent'}}, id: {id: 'child'}}", 'WhatEver').
            and_return('true')
          
          child.get_property_value('WhatEver', TrueClass).should be_true
        end  
      end
      
      describe "#invoke_tabular_method" do
        it "should get tabular data as two-dimensional array" do
          flex_app = mock('FlexApp')
          element = Element.new(flex_app, nil, {:id => 'box'})
          flex_app.should_receive(:invoke_tabular_method).and_return("a,b\nc,d")
          element.invoke_tabular_method("getValues", Table, 3, 4).should == [["a", "b"], ["c", "d"]]
        end
      end

      it "should raise error with Flex backtrace formatted as Ruby backtrace" do
        flex_error = %{____FUNFX_ERROR:
Error: Unable to resolve child for part 'undefined':'undefined' in parent 'FlexObjectTest'.
        at mx.automation::AutomationManager/resolveID()[C:\\work\\flex\\dmv_automation\\projects\\automation\\src\\mx\\automation\\AutomationManager.as:1332]
        at mx.automation::AutomationManager/resolveIDToSingleObject()[C:\\work\\flex\\dmv_automation\\projects\\automation\\src\\mx\\automation\\AutomationManager.as:1238]
        at funfx::Proxy/findAutomationObject()[C:\\scm\\funfx\\flex\\src\\funfx\\Proxy.as:46]
        at funfx::Proxy/fireEvent()[C:\\scm\\funfx\\flex\\src\\funfx\\Proxy.as:18]
        at Function/http://adobe.com/AS3/2006/builtin::apply()
        at <anonymous>()
        at flash.external::ExternalInterface$/_callIn()
        at <anonymous>()}

        element = Element.new(nil, nil, {})
        begin
          element.raise_if_funfx_error(flex_error)
          violated
        rescue => e
          e.message.should == "Error: Unable to resolve child for part 'undefined':'undefined' in parent 'FlexObjectTest'."
          e.backtrace[0..7].join("\n").should == %{C:/work/flex/dmv_automation/projects/automation/src/mx/automation/AutomationManager.as:1332:in `mx.automation::AutomationManager/resolveID()'
C:/work/flex/dmv_automation/projects/automation/src/mx/automation/AutomationManager.as:1238:in `mx.automation::AutomationManager/resolveIDToSingleObject()'
C:/scm/funfx/flex/src/funfx/Proxy.as:46:in `funfx::Proxy/findAutomationObject()'
C:/scm/funfx/flex/src/funfx/Proxy.as:18:in `funfx::Proxy/fireEvent()'
UNKNOWN:in `Function/http://adobe.com/AS3/2006/builtin::apply()'
UNKNOWN:in `<anonymous>()'
UNKNOWN:in `flash.external::ExternalInterface$/_callIn()'
UNKNOWN:in `<anonymous>()'}
          e.backtrace[8].should =~ /lib\/funfx\/flex\/element.rb:\d+:in `raise_if_funfx_error'/
        end
      end

      it "should try flex invoking with a max retry times" do
        flex_app = mock('FlexApp')
        FunFX.fire_max_tries = 5
        flex_app.should_receive(:fire_event_return_nil).exactly(4).and_return(nil)
        flex_app.should_receive(:fire_event_return_right_result).once.and_return("right result")
        def flex_app.fire_event(*args)
          @fire_event_times ||= 0
          @fire_event_times += 1
          if @fire_event_times < FunFX.fire_max_tries
            fire_event_return_nil
          else
            fire_event_return_right_result
          end
        end
        element = Element.new(flex_app, nil, {:id => 'box'})

        element.fire_event("keydown")
      end

      it "should raise error after retried flex invoking with a max retry times" do
        FunFX.fire_max_tries = 2

        flex_app = mock('FlexApp')
        element = Element.new(flex_app, nil, {:id => 'box'})
        flex_app.should_receive(:fire_event).exactly(3).times.and_return(nil)

        begin
          element.fire_event("keydown")
          violated
        rescue => e
          e.message.should == "Flex app is busy and seems to stay busy!"
        end
      end

      it "should raise the flex error threw from flex app after retried flex invoking with a max retry times" do
        FunFX.fire_max_tries = 2
        flex_error = %{____FUNFX_ERROR:
Error: Unable to resolve child for part 'undefined':'undefined' in parent 'FlexObjectTest'.
        at mx.automation::AutomationManager/resolveID()[C:\\work\\flex\\dmv_automation\\projects\\automation\\src\\mx\\automation\\AutomationManager.as:1332]
        at mx.automation::AutomationManager/resolveIDToSingleObject()[C:\\work\\flex\\dmv_automation\\projects\\automation\\src\\mx\\automation\\AutomationManager.as:1238]
        at funfx::Proxy/findAutomationObject()[C:\\scm\\funfx\\flex\\src\\funfx\\Proxy.as:46]
        at funfx::Proxy/fireEvent()[C:\\scm\\funfx\\flex\\src\\funfx\\Proxy.as:18]
        at Function/http://adobe.com/AS3/2006/builtin::apply()
        at <anonymous>()
        at flash.external::ExternalInterface$/_callIn()
        at <anonymous>()}

        flex_app = mock('FlexApp')
        element = Element.new(flex_app, nil, {:id => 'box'})
        flex_app.should_receive(:fire_event).exactly(3).times.and_return(flex_error)

        begin
          element.fire_event("keydown")
          violated
        rescue => e
          e.message.should == "Error: Unable to resolve child for part 'undefined':'undefined' in parent 'FlexObjectTest'."
        end
      end

      after(:all) do
        FunFX.fire_max_tries = nil
      end
    end
  end
end
