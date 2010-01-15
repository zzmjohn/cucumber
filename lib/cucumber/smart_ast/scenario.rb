require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Scenario < StepContainer
      include Comments
      include Tags
      include Description
      
      def initialize(keyword, description, line, tags, feature)
        super(keyword, description, line, feature)
        @feature = feature
        @tags = tags
      end

      def execute(step_mother, listener)
        # TODO: Very similar to what's in Example. Refactor.
        step_mother.before(self)
        listener.before_unit(self)

        all_steps.each do |step|
          step.execute(step_mother, listener)
        end

        listener.after_unit(self)
        step_mother.after(self)
      end

      def accept(visitor)
        visitor.visit_feature(@feature)
        visitor.visit_scenario(self)
      end

      def report_to(gherkin_listener)
        gherkin_listener.scenario(@keyword, @description, @line)
      end

      private
      
      def all_steps
        feature.background_steps + @steps
      end
    end
  end
end
