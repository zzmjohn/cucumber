require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class ScenarioOutline < StepContainer
      include Tags
      
      attr_reader :examples
      def examples(examples)
        @examples ||= []
        @examples << examples
        examples
      end
    end
  end
end
