module Cucumber
  module SmartAst
    class Examples
      def initialize(name, description, line)
        @name, @description, @line = name, description, line
      end
    end
  end
end
