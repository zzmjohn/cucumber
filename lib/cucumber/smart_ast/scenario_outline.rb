module Cucumber
  module SmartAst
    class ScenarioOutline
      def initialize(name, description, line)
        @name, @description, @line
      end
    end
  end
end
