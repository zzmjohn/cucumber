module Cucumber
  module SmartAst
    class Step 
      attr_reader :argument
      def initialize(adverb, body, line)
        @adverb, @body, @line = adverb, body, line
      end

      def table(rows, line)
        @argument = Table.new(rows, line)
      end

      def py_string(start_col, content, line)
        @argument = PyString.new(start_col, content, line)
      end
    end
  end
end
