module Cucumber
  module SmartAst
    class Step 
      attr_accessor :argument
      def initialize(adverb, body, line)
        @adverb, @body, @line = adverb, body, line
      end
    end
  end
end
