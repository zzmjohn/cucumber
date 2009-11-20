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

      def feature(kw, description, line)
        @ast.feature(kw, description, line)
        register_tags(@ast)
      end

      def background(kw, description, line)
        background = Background.new(kw, description, line) { |bg| bg.feature = @ast }
        @current = @ast.background(background)
      end

      def scenario(kw, description, line)
        scenario = Scenario.new(kw, description, line) { |s| s.feature = @ast }
        @current = @ast.scenario(scenario)
        register_tags(@current)
      end

      def scenario_outline(kw, description, line)
        scenario_outline = ScenarioOutline.new(kw, description, line) { |so| so.feature = @ast }
        @current = @ast.scenario_outline(scenario_outline)
        register_tags(@current)
      end

      def examples(kw, description, line)
        @current = @ast.examples(Examples.new(kw, description, line) { |ex| ex.feature = @ast })
        register_tags(@current)
      end

      def step(adverb, kw, line)
        @current.step(adverb, kw, line)
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
