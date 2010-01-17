module Cucumber
  module SmartAst
    class ResultCell
      def initialize(example, key, value)
        @example, @value = example, value
      end
    end
  end
end