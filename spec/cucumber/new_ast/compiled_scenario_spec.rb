require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/new_ast/compiled_scenario'
require 'cucumber/new_ast/compiled_feature'

module Cucumber
  module NewAst
    describe CompiledScenario do
      before(:each) do
        @ast_node = CompiledScenario.new(mock("ParseTreeScenario"))
      end

      it_should_behave_like 'an AstNode' 
    end
  end
end
