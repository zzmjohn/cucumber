module Cucumber
  module SmartAst
    class PyString
      def initialize(start_col, content, line)
        @start_col, @content, @line
      end
    end
  end
end
