module Cucumber
  module NewAst
    # Executes the Ast by walking it
    #
    class Runtime
      def execute(compiled_feature)
        visit(compiled_feature)
      end

      def visit(ast_node)
        ast_node.invoke
        ast_node.children.map { |child| execute(child) }
      end
    end
  end
end
