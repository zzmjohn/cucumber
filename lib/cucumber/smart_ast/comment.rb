module Cucumber
  module SmartAst
    class Comment
      def initialize(comment, line)
        @comment, @line = comment, line
      end
    end
  end
end
