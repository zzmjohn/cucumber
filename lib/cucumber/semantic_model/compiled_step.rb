require 'cucumber/semantic_model/node'

module Cucumber
  module SemanticModel
    class CompiledStep
      include Node

      def initialize(parse_tree_node, step_match)
        @parse_tree_node = parse_tree_node
        @step_match = step_match
      end

      def announce
        puts "  #{@parse_tree_node.keyword} #{@parse_tree_node.name}"
      end

      def invoke
        @step_match.invoke(nil)
      end
    end
  end
end
