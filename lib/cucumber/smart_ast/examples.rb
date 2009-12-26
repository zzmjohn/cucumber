require 'cucumber/smart_ast/scenario'

module Cucumber
  module SmartAst
    class Examples 
      include Tags
      
      attr_writer :steps
      attr_reader :parent
      def initialize(kw, description, line, parent)
        @kw, @description, @line, @parent = kw, description, line, parent
      end

      def table(table)
        @table = table
      end
      
      def name
        "#{@kw}: #{@description}"
      end
      
      def feature
        @parent.feature
      end
      
      def language
        @parent.language
      end
      
      def background_steps
        @parent.background_steps
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
