module Cucumber
  module SmartAst
    class Node
      attr_reader :keyword, :description, :line
      
      def initialize(keyword, description, line)
        @keyword, @description, @line = keyword, description, line
      end
    end
  end
end
