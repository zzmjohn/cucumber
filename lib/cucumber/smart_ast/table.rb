module Cucumber
  module SmartAst
    class Table
      def initialize(rows, line)
        @rows, @line = rows, line
      end
    end
  end
end
