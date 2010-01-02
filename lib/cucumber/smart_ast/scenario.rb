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
        @tags = tags + feature.tags
      end
      
      def create_table(rows, line)
        @steps.last.argument = Table.new(rows, line)
      end
      
      def from_outline?
        false
      end
      
      def feature
        return @parent
      end
      
      private
      
      def all_steps
        @parent.background_steps + self.steps
      end
    end
  end
end
