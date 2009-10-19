require 'cucumber/new_ast/feature'

module Cucumber
  module NewAst
    class Builder
      attr_reader :ast
      
      def feature(keyword, name, line)
        @ast = Feature.new(keyword, name, line)
      end

      def scenario(keyword, name, line)
        @step_container = @ast.scenario(keyword, name, line)
      end

      def step(keyword, name, line)
        @step_container.step(keyword, name, line)
      end
    end
  end
end