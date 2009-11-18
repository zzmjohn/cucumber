require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class ScenarioOutline < StepContainer
      include Steps
      include PyStrings

      attr_reader :examples
      def examples(examples)
        @examples ||= []
        @examples << examples
        examples
      end
    end
  end
end
