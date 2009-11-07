require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/new_ast/compiled_hook'

module Cucumber
  module NewAst
    describe CompiledHook do
      before(:each) do
        @ast_node = CompiledHook.new(mock("Hook"), mock("StepMother"))
      end

      it_should_behave_like 'an AstNode' 
    end
  end
end
