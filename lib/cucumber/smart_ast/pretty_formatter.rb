require 'gherkin/tools/pretty_listener'

module Cucumber
  module SmartAst
    class PrettyFormatter
      def initialize(_,io,__)
        @listener = Gherkin::Tools::PrettyListener.new(io)
      end

      def before_unit(unit)
        unit.report_to(@listener)
      end

      def after_step(step_result)
        step_result.report_to(@listener)
      end
      
      def after_unit(unit)
      end

      private

      def on_new_feature(unit)
        if @feature != unit.feature
          @feature = unit.feature
          yield @feature
        end
      end
      
      def on_new_scenario_outline
        if @scenario_outline != @scenario.scenario_outline
          @scenario_outline = @scenario.scenario_outline
          yield @scenario_outline
        end
      end
      
      def on_new_examples_table
        if @examples_table != @scenario.examples
          @examples_table = @scenario.examples
          yield @examples_table
        end
      end

    end
  end
end