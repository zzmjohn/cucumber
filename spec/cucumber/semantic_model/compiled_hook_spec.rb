require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/semantic_model/compiled_hook'

module Cucumber
  module SemanticModel
    describe CompiledHook do
      before(:each) do
        @sm_node = CompiledHook.new(mock("Hook"), mock("StepMother"))
      end

      it_should_behave_like 'a Semantic Model Node' 
    end
  end
end
