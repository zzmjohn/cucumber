require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/step'

module Cucumber
  module SmartAst
    describe Step do
      before do
        @step = Step.new("Given", "<num> Cucumbers in my <object>", 1)
        @args = { "num" => "5", "object" => "bucket" }        
      end
      
      it "should interpolate variable arguments" do
        @step.interpolate(@args).should == Step.new("Given", "5 Cucumbers in my bucket", 1)
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
    end
  end
end
