require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Examples 
      include Tags
      include Description
      extend Forwardable
      
      attr_reader :keyword
      attr_writer :steps
      attr_accessor :table

      def initialize(keyword, description, line, parent)
        @keyword, @description, @line, @parent = keyword, description, line, parent
      end
      
      def_delegators :scenario_outline, 
        :language, 
        :feature, 
        :background_steps

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
