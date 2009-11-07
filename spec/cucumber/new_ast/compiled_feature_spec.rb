require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/new_ast/compiled_feature'

module Cucumber
  module NewAst
    describe CompiledFeature do
      before(:each) do
        @ast_node = CompiledFeature.new
      end

      it_should_behave_like 'an AstNode' 
    end
  end
end
