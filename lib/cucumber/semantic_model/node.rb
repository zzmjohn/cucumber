module Cucumber
  module SemanticModel
    module Node
   
      attr_accessor :parent

      def children
        @children ||= []
      end

      def announce
      end

      def add_child(node)
        children << node
        node.parent = self
      end

      def accept(visitor)
        visitor.visit(self)
      end

      def invoke
      end
    end
  end
end

