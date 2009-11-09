require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/semantic_model/compiled_feature'
require 'cucumber/semantic_model/compiled_scenario'

module Cucumber
  module SemanticModel
    describe CompiledFeature do
      before(:each) do
        @sm_node = CompiledFeature.new
      end

      it_should_behave_like 'a Semantic Model Node' 

      it "should set itself as parent when adding a child" do
        comp_scenario = CompiledScenario.new(nil)
        @sm_node.add_child(comp_scenario)
        comp_scenario.parent.should == @sm_node
      end
    end
  end
end
