require 'cucumber/semantic_model/node'

module Cucumber
  module SemanticModel
    class CompiledStep
      include Node

      def initialize(ast_node, step_match)
        @ast_node = ast_node
        @step_match = step_match
      end

      def announce
        puts "  #{@ast_node.keyword} #{@ast_node.name}"
      end

      def invoke
        @step_match.invoke(nil)
      end
    end
  end
end
