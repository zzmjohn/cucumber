require 'cucumber/smart_ast/step_template'
require 'cucumber/smart_ast/examples'
require 'cucumber/smart_ast/example'

module Cucumber
  module SmartAst
    class ScenarioOutline
      include Comments
      include Tags
      include Description
      
      def initialize(keyword, description, line, tags, feature)
        @keyword, @description, @line, @tags, @feature = keyword, description, line, tags, feature
        @step_templates = []
      end
      
      def create_examples(keyword, description, line, tags)
        examples = Examples.new(keyword, description, line, tags, self)
      end

      def create_example(row, row_index)
        examples = Example.new(self, row, row_index)
      end
      
      def create_step(keyword, name, line)
        step_template = StepTemplate.new(keyword, name, line)
        @step_templates << step_template
        step_template
      end

      def execute(header, row, step_mother, listener)
        @step_templates.each do |step_template|
          step_template.execute(header, row, step_mother, listener)
        end
      end

      def accept(visitor)
        @feature.accept(visitor)
        visitor.visit_scenario_outline(self)
      end

      def report_to(gherkin_listener)
        gherkin_listener.scenario(@keyword, @description, @line)
        @step_templates.each do |step_template|
          step_template.report_to(gherkin_listener)
        end
      end
    end
  end
end
