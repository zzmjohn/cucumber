module Cucumber
  module NewAst
    module AstNode
   
      attr_accessor :parent

      def children
        @children ||= []
      end

      def announce
      end

      def add_child(ast_node)
        children << ast_node
      end

      def accept(visitor)
        visitor.visit(self)
      end

      def invoke
      end
    end
  end
end

