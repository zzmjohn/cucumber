module Cucumber
  module SmartAst
    class Step 
      attr_accessor :argument
      attr_reader :adverb, :name, :line
      def initialize(adverb, name, line)
        @adverb, @name, @line = adverb, name, line
      end
    end
  end
end
