require 'cucumber/smart_ast/feature'
require 'cucumber/smart_ast/background'
require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/scenario_outline'
require 'cucumber/smart_ast/examples'

module Cucumber
  module SmartAst
    class Builder
      attr_reader :ast

      def initialize
        @current = @ast = Feature.new
        @tag_cache = []
      end

      def feature(name, description, line)
        @ast.feature(name, description, line)
        register_tags(@ast)
      end

      def background(name, description, line)
        @current = @ast.background(Background.new(name, description, line))
      end

      def scenario(name, description, line)
        scenario = Scenario.new(name, description, line)
        scenario.feature = @ast
        @current = @ast.scenario(scenario)
        register_tags(@current)
      end

      def scenario_outline(name, description, line)
        @current = @ast.scenario_outline(ScenarioOutline.new(name, description, line))
        register_tags(@current)
      end

      def examples(name, description, line)
        @current = @ast.examples(Examples.new(name, description, line))
        register_tags(@current)
      end

      def step(adverb, name, line)
        @current.step(adverb, name, line)
      end

      def table(rows, line)
        @current.table(rows, line)
      end

      def py_string(start_col, content, line)
        @current.py_string(start_col, content, line)
      end

      def tag(tag, line)
        @tag_cache << [tag, line]
      end

      def comment(comment, line)
      end

      private

      def register_tags(container)
        @tag_cache.each { |tag| @current.tag(tag[0], tag[1]) }
        @tag_cache.clear
      end
    end
  end
end
