module Cucumber
  module SmartAst
    class PyString
      def initialize(start_col, content, line)
        @start_col, @content, @line = start_col, content, line
      end

      def to_s
        @content
      end
    end
  end
end
