module Cucumber
  module SemanticModel
    # Executes the Ast by walking it
    #
    class Runtime
      def execute(node)
        visit(node)
      end

      def visit(node)
        node.invoke
        node.children.map { |child| execute(child) }
      end
    end
  end
end
