module Cucumber
  module SmartAst
    class Tag
      def initialize(tag, line)
        @tag, @line = tag, line
      end
    end
  end
end
