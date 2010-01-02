require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/description'

module Cucumber
  module SmartAst
    class Examples < StepContainer
      include Tags
      include Description
      extend Forwardable
      
      attr_reader :keyword, :scenario_outline
      attr_writer :steps
      attr_accessor :table

      def_delegators :scenario_outline, 
        :language, 
        :feature, 
        :background_steps

      def create_step(keyword, name, line)
        step = Step.new(adverb, keyword, line)
        @steps << steps
        step
      end
      
      def create_table(rows, line)
        table = Table.new(rows, line)
        table.rows.each do |row|
          p row
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
