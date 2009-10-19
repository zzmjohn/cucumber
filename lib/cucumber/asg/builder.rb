require 'cucumber/asg/unit'

module Cucumber
  module Asg
    # Builds an Asg by walking the Ast
    class Builder
      def initialize
        @units = []
      end

      def visit_feature(feature)
        @background_steps = []
        feature.accept(self)
      end

      def visit_background(background)
        @steps = @background_steps
        background.accept(self)
      end

      def visit_scenario(element)
        @steps = []
        element.accept(self)
        store_unit(@steps)
      end

      def visit_scenario_outline(element)
        @scenario_outline_steps = []
        @steps = @scenario_outline_steps
        @all_row_steps = []
        element.accept(self)
        @all_row_steps.each do |row_steps|
          store_unit(row_steps)
        end
      end

      def visit_examples(examples)
        examples.accept(self)
      end

      def visit_examples_table(table)
        table.accept(self)
      end

      def visit_table_row(cells)
        row_steps = @scenario_outline_steps.map do |step|
          step.clone_from_cells(cells)
        end
        @all_row_steps << row_steps
      end

      def visit_step(step)
        @steps << step
      end

      private
      
      def store_unit(steps)
        @units << Unit.new(@background_steps + steps)
      end
    end
  end
end