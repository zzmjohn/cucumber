require 'cucumber/asg/compiled_scenario'
require 'cucumber/asg/compiled_step'

module Cucumber
  module Asg
    # Builds an Asg by walking the Ast
    class Compiler
      def initialize(compiled_feature)
        @compiled_feature = compiled_feature
      end

      def visit_feature(ast_feature)
        @background_steps = []
        ast_feature.accept(self)
      end

      def visit_background(ast_background)
        @ast_steps = @background_steps
        ast_background.accept(self)
      end

      def visit_scenario(ast_scenario)
        @ast_steps = []
        ast_scenario.accept(self)
        compile_scenario(ast_scenario, @ast_steps)
      end

      def visit_scenario_outline(ast_scenario_outline)
        @ast_scenario_outline_steps = []
        @ast_steps = @ast_scenario_outline_steps
        @all_ast_row_steps = []
        ast_scenario_outline.accept(self)
        @all_ast_row_steps.each do |ast_row_steps|
          compile_scenario(ast_scenario_outline, ast_row_steps)
        end
      end

      def visit_examples(ast_examples)
        ast_examples.accept(self)
      end

      def visit_examples_table(ast_examples_table)
        ast_examples_table.accept(self)
      end

      def visit_table_row(ast_examples_table_cells)
        ast_row_steps = @ast_scenario_outline_steps.map do |ast_step|
          ast_step.clone_from_cells(ast_examples_table_cells)
        end
        @all_ast_row_steps << ast_row_steps
      end

      def visit_step(ast_step)
        @ast_steps << ast_step
      end

      private
      
      def compile_scenario(ast_has_steps, steps)
        compiled_steps = (@background_steps + steps).map {|step| CompiledStep.new(step)}
        @compiled_feature.add_compiled_scenario(CompiledScenario.new(ast_has_steps, compiled_steps))
      end
    end
  end
end