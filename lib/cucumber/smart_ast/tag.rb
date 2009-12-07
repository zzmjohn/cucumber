module Cucumber
  module SmartAst
    class Tag
      attr_reader :name
      def initialize(name, line)
        @name, @line = name, line
      end
    end
  end
end
