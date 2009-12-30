require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Enumerable
      include Comments
      include Tags
      include Description
      
      def initialize(keyword, description, line, tags, feature)
        super(keyword, description, line, feature)
        @tags = tags
      end
      
      def each(&block)
        @steps.each { |step| yield step }
      end
      
      def from_outline?
        !@parent.is_a?(Cucumber::SmartAst::Feature)
      end
      
      def feature
        return @parent unless from_outline?
        examples.feature
      end
      
      def outline
        return nil unless from_outline?
        examples.scenario_outline
      end
      
      def examples
        return nil unless from_outline?
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
