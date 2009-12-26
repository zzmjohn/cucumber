require 'cucumber/smart_ast/executor'
module Cucumber
  module SmartAst
    class Features < Array
      def execute(step_mother, listeners)
        Executor.new(step_mother, listeners).execute(self.first)
      end
    end
  end
end