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
      
      def background_steps
        @parent.background_steps
      end
      
      def feature
        @parent
      end
      
      def language
        @parent.language
      end
      
      def title
        @description.split("\n").first
      end

      def each(&block)
        @examples.each { |examples| yield examples }
      end
    end
  end
end
