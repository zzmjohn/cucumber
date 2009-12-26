require 'cucumber/smart_ast/step_container'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Enumerable
      include Comments
      include Tags
      
      def each(&block)
        @steps.each { |step| yield step }
      end
      
      def name
        "Scenario: #{@description}"
      end
      
      def all_steps
        feature.background_steps + self.steps
      end
      
      def all_tags
        (feature.tags + self.tags).uniq
      end
    end
  end
end
