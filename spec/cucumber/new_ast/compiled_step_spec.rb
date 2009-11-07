require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/new_ast/compiled_scenario'
require 'cucumber/new_ast/compiled_feature'
require 'cucumber/new_ast/compiled_step'

module Cucumber
  module NewAst
    describe CompiledStep do
      before(:each) do
        @ast_node = CompiledStep.new(mock("ParseTree::Step"), mock("StepMother"), mock("CompiledScenario"))
      end

      it_should_behave_like 'an AstNode' 
    end
  end
end
