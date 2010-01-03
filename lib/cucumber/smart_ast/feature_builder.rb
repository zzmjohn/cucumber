require 'cucumber/smart_ast/feature'
require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/scenario_outline'
require 'cucumber/smart_ast/examples'
require 'cucumber/smart_ast/step'
require 'cucumber/smart_ast/py_string'
require 'cucumber/smart_ast/table'
require 'cucumber/smart_ast/tag'
require 'cucumber/smart_ast/comment'
require 'cucumber/smart_ast/node'

module Cucumber
  module SmartAst
    class FeatureBuilder
      attr_reader :units
      
      def initialize
        @tags = []
        @units = []
      end
      
      def feature(keyword, description, line)
        @current_feature = Feature.new(keyword, description, line, grab_tags!)
      end

      def background(keyword, description, line)
        background = @current_feature.create_background(keyword, description, line)
        @current_step_container = background
      end

      def scenario(keyword, description, line)
        scenario = @current_feature.create_scenario(keyword, description, line, grab_tags!)
        @current_step_container = scenario
        @units << scenario
      end

      def scenario_outline(keyword, description, line)
        scenario_outline = @current_feature.create_scenario_outline(keyword, description, line, grab_tags!)
        @current_scenario_outline = @current_step_container = scenario_outline
      end

      def examples(keyword, description, line)
        @cached_examples_node = Node.new(keyword, description, line)
      end

      def step(keyword, name, line)
        @current_step_container.add_step!(keyword, name, line)
      end

      def table(rows, line)
        table = Table.new(rows, line)
        if @cached_examples_node
          create_examples(table) do |example|
            @units << example
          end
          @cached_examples_node = nil
        else
          @current_step_container.steps.last.argument = table
        end
      end

      def py_string(content, line)
        @current_step_container.steps.last.argument = PyString.new(content, line)
      end

      def tag(tag, line)
        @tags << Tag.new(tag, line)
      end

      def comment(comment, line)
      end
      
      def language=(language)
        @current_feature.language = language
      end

      private
      
      def create_examples(table, &block)
        @current_scenario_outline.create_examples(
          @cached_examples_node.keyword, 
          @cached_examples_node.description, 
          @cached_examples_node.line, 
          grab_tags!,
          table, 
          &block)
      end
      
      def grab_tags!
        result = @tags.dup
        @tags.clear
        result
      end

    end
  end
end
