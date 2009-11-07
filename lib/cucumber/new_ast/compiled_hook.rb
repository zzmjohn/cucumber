require 'cucumber/new_ast/ast_node'

module Cucumber
  module NewAst
    class CompiledHook
      include AstNode

      def initialize(language_hook, step_mother, parent=nil)
        @hook = language_hook
        @parent = parent
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
