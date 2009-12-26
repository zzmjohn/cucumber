require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Enumerable
      include Comments
      include Tags
      include Description
      
      def initialize(keyword, description, line, parent)
        valid_parents = [Cucumber::SmartAst::Feature, Cucumber::SmartAst::Examples]
        unless valid_parents.include?(parent.class)
          raise(ArgumentError, "parent must be a Feature or Examples but was #{parent.class}") 
        end
        super
      end
      
      def each(&block)
        @steps.each { |step| yield step }
      end
      
      def outline?
        !@parent.is_a?(Cucumber::SmartAst::Feature)
      end
      
      def feature
        return @parent unless outline?
        examples.feature
      end
      
      def outline
        return nil unless outline?
        examples.scenario_outline
      end
      
      def examples
        return nil unless outline?
        @parent
      end
      
      def all_steps
        @parent.background_steps + self.steps
      end
      
      def all_tags
        (@parent.tags + self.tags).uniq
      end
    end
  end
end
