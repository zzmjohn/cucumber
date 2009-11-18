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
      end

      def feature(name, description, line)
        @ast.feature(name, description, line)
      end

      def background(name, description, line)
        @current = @ast.background(Background.new(name, description, line))
      end

      def scenario(name, description, line)
        @current = @ast.scenario(Scenario.new(name, description, line))
      end

      def scenario_outline(name, description, line)
        @current = @ast.scenario_outline(ScenarioOutline.new(name, description, line))
      end

      def examples(name, description, line)
        @current = @ast.examples(Examples.new(name, description, line))
      end

      def step(adverb, body, line)
        @current.step(adverb, body, line)
      end

      def table(rows, line)
        @current.table(rows, line)
      end

      def py_string(start_col, content, line)
        @current.py_string(start_col, content, line)
      end

      def tag(tag, line)
        @current.tag(tag, line)
      end

      def comment(comment, line)
        @current.comment(tag, line)
      end
    end
  end
end
