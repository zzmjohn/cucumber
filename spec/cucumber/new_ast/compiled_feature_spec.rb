require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/new_ast/compiled_feature'
require 'cucumber/new_ast/compiled_scenario'

module Cucumber
  module NewAst
    describe CompiledFeature do
      before(:each) do
        @ast_node = CompiledFeature.new
      end

      it_should_behave_like 'an AstNode' 

      it "should set itself as parent when adding a child" do
        comp_scenario = CompiledScenario.new(nil)
        @ast_node.add_child(comp_scenario)
        comp_scenario.parent.should == @ast_node
      end
    end
  end
end
