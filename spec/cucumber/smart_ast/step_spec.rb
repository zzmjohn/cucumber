require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/step'
require 'cucumber/smart_ast/py_string'
require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    describe Step do
      before do
        @step = Step.new("Given", "<num> Cucumbers in my <object>", 1)
        @args = { "num" => "5", "object" => "bucket", "foo" => "bar" }
      end
      
      it "should interpolate variable arguments" do
        @step.interpolate(@args).should == Step.new("Given", "5 Cucumbers in my bucket", 1)
      end
      
      it "should store the inerpolated arguments" do
        @step.interpolate(@args).interpolated_arguments.should == ["5", "bucket"]
      end
      
      it "should return a new object when interpolating to preserve its status as a Value" do
        @step.interpolate(@args).should_not === @step
      end
      
      it "should be equal to another step of the same name" do
        @step.should == Step.new("Then", "<num> Cucumbers in my <object>", 2112)
      end
      
      it "should or should not be equal to another step of the same name but different argument" do
        pending("Not sure about the correct behavior here yet")
        @step.argument = "Blah pystring"
        second = Step.new("When", "I am unsure", 3)
        second.argument = "pystring blah"
        @step.should == second
      end
      
      context "formatting for execution" do
        before do
          @step = Step.new("Given", "a step", 1)
        end
        
        it "should include nil when there is no multiline argument" do
          @step.to_execution_format.should == ["a step", nil]
        end
        
        it "should return a string for a py_string" do
          @step.argument = PyString.new("Oh hai", 1)
          @step.to_execution_format.should == ["a step", "Oh hai"]
        end
        
        it "should return the table object for a table" do
          table = Table.new([%w{ 1 2 3 }], 1)
          @step.argument = table
          @step.to_execution_format.should == ["a step", table]
        end
      end
    end
  end
end
