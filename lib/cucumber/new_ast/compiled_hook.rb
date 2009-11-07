require 'cucumber/new_ast/ast_node'

module Cucumber
  module NewAst
    class CompiledHook
      include AstNode

      def initialize(language_hook, step_mother)
        @hook = language_hook
        @step_mother = step_mother
      end

      def invoke
        @hook.invoke(@step_mother, @parent)
      end
 
      def name
        @parse_tree_node.name
      end
    end
  end
end
