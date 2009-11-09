require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/semantic_model/compiled_scenario'
require 'cucumber/semantic_model/compiled_feature'
require 'cucumber/semantic_model/compiled_step'

module Cucumber
  module SemanticModel
    describe CompiledStep do
      before(:each) do
        @sm_node = CompiledStep.new(mock("ParseTree::Step"), mock("StepMother"))
      end

      it_should_behave_like 'a Semantic Model Node' 
    end
  end
end
