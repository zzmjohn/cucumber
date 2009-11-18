module Cucumber
  module SmartAst
    class Step
      def initialize(adverb, body, line)
        @adverb, @body, @line = adverb, body, line
      end
    end
  end
end
