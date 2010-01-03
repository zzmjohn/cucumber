require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/step_template'
require 'cucumber/smart_ast/examples'
require 'cucumber/smart_ast/example'

module Cucumber
  module SmartAst
    class ScenarioOutline < StepContainer
      include Enumerable
      include Tags
      include Description
      
      def initialize(keyword, description, line, tags, feature)
        super(keyword, description, line, feature)
        @tags = tags
      end
      
      def create_examples(keyword, description, line, tags, table)
        examples = Examples.new(keyword, description, line, tags, table, self)
        
        table.hashes.each_with_index do |row, row_index|
          steps = generate_steps(row, table.headers)
          yield Example.new(row, table.line + row_index, steps, examples) if block_given?
        end
      end
      
      def add_step!(keyword, name, line)
        @steps << StepTemplate.new(keyword, name, line, self)
      end
      
      def background_steps
        return [] unless feature
        feature.background_steps
      end
      
      def feature
        @parent
      end
      
      def language
        @parent.language
      end
      
      private
      
      def generate_steps(table_row, headers)
        generated_steps = @steps.map do |step|
          step.interpolate(table_row, headers)
        end
        background_steps + generated_steps
      end
    end
  end
end
