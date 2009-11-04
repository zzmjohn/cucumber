require 'cucumber/new_ast/compiled_scenario'
require 'cucumber/new_ast/compiled_step'

module Cucumber
  module NewAst
    # Builds an Ast by walking the Ast
    class Compiler
      def initialize(step_mother, compiled_feature)
        @step_mother = step_mother
        @compiled_feature = compiled_feature
      end

      def visit_feature(parse_tree_feature)
        @background_steps = []
        parse_tree_feature.accept(self)
      end

      def visit_background(parse_tree_background)
        @ast_steps = @background_steps
        parse_tree_background.accept(self)
      end

      def visit_scenario(parse_tree_scenario)
        @ast_steps = []
        parse_tree_scenario.accept(self)
        compile_scenario(parse_tree_scenario, @ast_steps)
      end

      def visit_scenario_outline(parse_tree_scenario_outline)
        @ast_scenario_outline_steps = []
        @ast_steps = @ast_scenario_outline_steps
        @all_ast_row_steps = []
        parse_tree_scenario_outline.accept(self)
        @all_ast_row_steps.each do |ast_row_steps|
          compile_scenario(ast_scenario_outline, ast_row_steps)
        end
      end

      def visit_examples(parse_tree_examples)
        parse_tree_examples.accept(self)
      end

      def visit_examples_table(parse_tree_examples_table)
        parse_tree_examples_table.accept(self)
      end

      def visit_table_row(parse_tree_examples_table_cells)
        ast_row_steps = @ast_scenario_outline_steps.map do |ast_step|
          ast_step.clone_from_cells(parse_tree_examples_table_cells)
        end
        @all_ast_row_steps << ast_row_steps
      end

      def visit_step(parse_tree_step)
        @ast_steps << parse_tree_step
      end

      private
      
      def compile_scenario(parse_tree_has_steps, steps)
        all_steps = (@background_steps + steps)
        compiled_scenario = CompiledScenario.new(parse_tree_has_steps)
        all_steps.map {|step| compiled_scenario.add_child(CompiledStep.new(step,@step_mother,compiled_scenario)) }
        @compiled_feature.add_child(compiled_scenario)
      end
    end
  end
end
