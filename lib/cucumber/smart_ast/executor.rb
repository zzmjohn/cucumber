module Cucumber
  module SmartAst
    class Executor
      def initialize(step_mother)
        @step_mother = step_mother
      end

      def execute(ast)
        count = 0
        background = ast.background
        ast.scenarios.each do |scenario|
          count += [background.steps + scenario.steps].flatten.size
        end
        count
      end
    end
  end
end
