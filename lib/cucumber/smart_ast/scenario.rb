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
      
      def outline?
        !parent.is_a?(Cucumber::SmartAst::Feature)
      end
      
      def outline
        return nil unless outline?
        examples.parent
      end
      
      def examples
        return nil unless outline?
        parent
      end
      
      def title
        @description.split("\n").first
      end
      
      def all_steps
        parent.background_steps + self.steps
      end
      
      def all_tags
        (parent.tags + self.tags).uniq
      end
    end
  end
end
