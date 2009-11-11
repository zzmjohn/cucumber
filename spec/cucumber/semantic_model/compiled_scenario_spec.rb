require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/semantic_model/compiled_scenario'

module Cucumber
  module SemanticModel
    describe CompiledScenario do
      before(:each) do
        @sm_node = CompiledScenario.new(mock("ParseTreeScenario"))
      end

      it_should_behave_like 'a Semantic Model Node' 
    end
  end
end
