require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Examples 
      include Tags
      include Description
      
      attr_reader :keyword
      attr_writer :steps
      attr_accessor :table

      def initialize(keyword, description, line, parent)
        @keyword, @description, @line, @parent = keyword, description, line, parent
      end

      def language
        scenario_outline.language
      end
      
      def feature
        scenario_outline.feature
      end

      def background_steps
        scenario_outline.background_steps
      end
      
      def scenario_outline
        @parent
      end
      
      def scenarios
        scenarios = []
        @table.hashes.each_with_index do |row, idx|
          scenario = Scenario.new("Scenario", row.values.join(" | "), @table.line + idx, self)
          scenario.steps = @steps.collect { |step| step.interpolate(row) }
          scenarios << scenario
        end
        scenarios
      end
    end
  end
end
