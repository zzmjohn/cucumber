require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/scenario_step'
require 'cucumber/smart_ast/step_template'
require 'cucumber/smart_ast/py_string'
require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    describe ScenarioStep do
      context "formatting for execution" do
        before do
          @step = ScenarioStep.new("Given", "a step", 1, nil)
        end
        
        it "should include nil when there is no multiline argument" do
          @step.to_execution_format.should == ["a step", nil]
        end
        
        it "should return a string for a py_string" do
          @step.py_string!("Oh hai", 1)
          @step.to_execution_format.should == ["a step", "Oh hai"]
        end
        
        it "should return the table object for a table" do
          @step.table!([%w{ 1 2 3 }], 1)
          @step.to_execution_format[0].should == "a step"
          @step.to_execution_format[1].raw.should == [%w{ 1 2 3 }]
        end
      end
    end
  end
end
