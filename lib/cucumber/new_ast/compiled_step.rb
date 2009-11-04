require 'cucumber/new_ast/ast_node'

module Cucumber
  module NewAst
    class CompiledStep
      include AstNode

      def initialize(parse_tree_node, step_mother, compiled_scenario)
        @parse_tree_node = parse_tree_node
        @step_mother = step_mother
        @compiled_scenario = compiled_scenario
      end

      def announce
        puts "  #{@parse_tree_node.keyword} #{@parse_tree_node.name}"
      end

      def invoke
        step_match = @step_mother.step_match(name, name)
        step_match.invoke(nil)
      end
 
      def name
        @parse_tree_node.name
      end
    end
  end
end
