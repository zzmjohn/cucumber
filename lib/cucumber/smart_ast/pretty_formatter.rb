require 'cucumber/smart_ast/pretty_printer'
module Cucumber
  module SmartAst
    class PrettyFormatter
      def initialize(_,io,__)
        @printer = PrettyPrinter.new(io)
      end
      
      def before_unit(unit)
        @scenario = unit
        
        on_new_feature do |feature|
          @printer.feature(feature)
        end
        
        if @scenario.from_outline?
          on_new_scenario_outline do |scenario_outline|
            @printer.scenario_outline(scenario_outline)
          end
          
          on_new_examples_table do |examples_table|
            @printer.examples_table(examples_table)
          end
        else
          @printer.scenario(@scenario)
        end
      end
      
      def after_step(step_result)
        step_result.accept(@printer)
      end
      
      def after_unit(unit_result)
        @printer.after_example(unit_result) if @scenario.from_outline?
      end
      
      private

      def on_new_feature
        if @feature != @scenario.feature
          @feature = @scenario.feature
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