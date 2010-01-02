require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/example'

module Cucumber
  module SmartAst
    class Examples < StepContainer
      include Tags
      include Description
      extend Forwardable
      
      attr_reader :keyword
      attr_writer :steps
      attr_accessor :table
      
      def scenario_outline
        @parent
      end

      def_delegators :scenario_outline, 
        :language,
        :feature,
        :background_steps

      def headers
        @table.headers
      end

      def create_table(rows, table_line)
        @table = Table.new(rows, table_line)
        @table.hashes.each_with_index do |row, index|
          yield Example.new(row, table_line + index, self)
        end
      end

      def scenarios
        scenarios = []
        @table.hashes.each_with_index do |row, idx|
          scenario = Scenario.new("Scenario", row.values.join(" | "), @table.line + idx, self)
          scenario.steps = @steps.collect { |step| step.interpolate(row, @table.headers) }
          scenarios << scenario
        end
        scenarios
      end
    end
  end
end
