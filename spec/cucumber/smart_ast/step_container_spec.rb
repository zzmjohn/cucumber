require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/py_string'

module Cucumber
  module SmartAst
    describe StepContainer do
      before do
        @step_container = StepContainer.new("Test", "Step container test", 1, nil)
      end

      it "should have a list of steps" do
        @step_container.steps << Step.new("Given", "I am a step", 2, nil)
        @step_container.steps << Step.new("And", "I am another step", 3, nil)
        @step_container.should have(2).steps
      end
    end
  end
end

