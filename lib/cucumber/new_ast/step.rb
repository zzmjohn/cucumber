module Cucumber
  module NewAst
    class Step
      attr_reader :keyword, :name, :line
      
      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
      end

      def table(raw, line)
      end

      def py_string(string, line, col)
      end
    end
  end
end