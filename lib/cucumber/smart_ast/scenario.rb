module Cucumber
  module SmartAst
    class Scenario
      def initialize(name, description, line)
        @name, @description, @line
      end
    end
  end
end
