module Cucumber
  module SemanticModel
    # Executes the Ast by walking it
    #
    class Runtime
      def execute(compiled_feature)
        visit(compiled_feature)
      end

      def visit(node)
        node.invoke
        node.children.map { |child| execute(child) }
      end
    end
  end
end
