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

module Cucumber
  module SmartAst
    class Builder
      attr_reader :ast

      def initialize
        @current = @ast = Feature.new
        @tag_cache = []
      end

      def feature(keyword, description, line)
        @ast.feature(keyword, description, line)
        register_tags
      end

      def background(keyword, description, line)
        @current = @ast.background = StepContainer.new(keyword, description, line, @ast)
      end

      def scenario(keyword, description, line)
        scenario = Scenario.new(keyword, description, line, @ast)
        @current = @ast.scenario(scenario)
        register_tags
      end

      def scenario_outline(keyword, description, line)
        scenario_outline = ScenarioOutline.new(keyword, description, line, @ast)
        @current = @ast.scenario_outline(scenario_outline)
        register_tags
      end

      def examples(keyword, description, line)
        @current = @ast.examples(Examples.new(keyword, description, line, @current))
        register_tags
      end

      def step(adverb, keyword, line)
        @current.steps << Step.new(adverb, keyword, line)
      end

      def table(rows, line)
        @current.table = Table.new(rows, line)
      end

      def py_string(content, line)
        @current.py_string = PyString.new(content, line)
      end

      def tag(tag, line)
        @tag_cache << [tag, line]
      end

      def comment(comment, line)
      end
      
      def language=(language)
        @ast.language = language
      end

      private

      def register_tags
        @tag_cache.each { |tag| @current.tags << Tag.new(tag[0], tag[1]) }
        @tag_cache.clear
      end    
    end
  end
end
