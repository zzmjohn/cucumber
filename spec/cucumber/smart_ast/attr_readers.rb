require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      def feature
        @parent
      end
    end
  end
end