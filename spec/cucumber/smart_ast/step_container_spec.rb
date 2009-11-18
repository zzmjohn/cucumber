require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class TestContainer < StepContainer
      include Steps
      include Tables
    end

    describe StepContainer do
      before do
        @step_container = TestContainer.new("Test", "Step container test", 1)
      end

      it "should have a list of steps" do
        @step_container.step("Given", "I am a step", 2)
        @step_container.step("And", "I am another step", 3)
        @step_container.should have(2).steps
      end

      it "should include the table argument to a step" do
        @step_container.step("Given", "a table", 2)
        rows = [%w(a b), %w(c d)]
        @step_container.table(rows, 3)
        @step_container.should have(1).steps
        step = @step_container.steps.first
        step.argument.should == rows
      end

      it "should include py_string argument to a step" do
        @step_container.step("Given", "a py_string", 2)
        py_string = "Long string"
        @step_container.py_string(1, py_string, 3)
        @step_container.steps.first.argument.should == py_string
      end
    end
  end
end

