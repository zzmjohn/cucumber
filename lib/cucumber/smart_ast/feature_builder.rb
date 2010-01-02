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
    class FeatureBuilder
      
      attr_reader :units
      
      def initialize
        @tags = []
        @units = []
      end
      
      def feature(keyword, description, line)
        @current = @current_feature = Feature.new(keyword, description, line, grab_tags!)
      end

      def background(keyword, description, line)
        @current = @current.create_background(keyword, description, line)
      end

      def scenario(keyword, description, line)
        @current = @current_feature.create_scenario(keyword, description, line, grab_tags!)
        @units << @current
      end

      def scenario_outline(keyword, description, line)
        @current = @current_feature.create_scenario_outline(keyword, description, line, grab_tags!)
      end

      def examples(keyword, description, line)
        @current = @current.create_examples(keyword, description, line, grab_tags!)
      end

      def step(keyword, name, line)
        @current.add_step!(keyword, name, line)
      end

      def table(rows, line)
        @current.create_table(rows, line) do |unit|
          @units << unit
        end
      end

      def py_string(content, line)
        @current.py_string = PyString.new(content, line)
      end

      def tag(tag, line)
        @tags << Tag.new(tag, line)
      end

      def comment(comment, line)
      end
      
      def language=(language)
        @feature.language = language
      end

      private
      
      def grab_tags!
        result = @tags.dup
        @tags.clear
        result
      end

    end
  end
end
