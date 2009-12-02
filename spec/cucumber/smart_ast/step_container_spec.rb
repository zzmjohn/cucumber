require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    describe StepContainer do
      before do
        @step_container = StepContainer.new("Test", "Step container test", 1)
      end

      it "should have a list of steps" do
        @step_container.step("Given", "I am a step", 2)
        @step_container.step("And", "I am another step", 3)
        @step_container.should have(2).steps
      end

      it "should include the table argument to a step" do
        rows = [%w(a b), %w(c d)]
        @step_container.step("Given", "a table", 2)
        @step_container.table(rows, 3)
        @step_container.should have(1).steps
        @step_container.steps[0].argument.raw.should == rows
      end

      it "should include py_string argument to a step" do
        content = "Long string"
        @step_container.step("Given", "a py_string", 2)
        @step_container.py_string(content, 3)
        @step_container.steps[0].argument.to_s.should == content
      end

      it "should handle many steps with arguments" do
        rows = [[1, 2]]
        content = "PyString!"

        @step_container.step("Given", "a normal step", 2)
        @step_container.step("When", "a table", 3)
        @step_container.table(rows, 4)
        @step_container.step("Then", "a py_string", 5)
        @step_container.py_string(content, 6)
        @step_container.step("And", "another normal step", 7)

        @step_container.should have(4).steps
        @step_container.steps[1].argument.raw.should == rows
        @step_container.steps[2].argument.to_s.should == content
      end
    end
  end
end

