require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class ScenarioOutline < StepContainer
      include Enumerable
      include Tags
      
      def examples(examples)
        @examples ||= []
        examples.steps = @steps
        @examples << examples
        examples
      end

      def scenarios
        scenarios = []
        @examples.each do |example|
          example.scenarios.each do |scenario|
            scenarios << scenario
          end
        end
        scenarios
      end

      def each(&block)
        @examples.each { |examples| yield examples }
      end
    end
  end
end
