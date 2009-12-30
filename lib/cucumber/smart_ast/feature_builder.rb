require 'cucumber/smart_feature/feature'
require 'cucumber/smart_feature/step_container'
require 'cucumber/smart_feature/scenario'
require 'cucumber/smart_feature/scenario_outline'
require 'cucumber/smart_feature/examples'
require 'cucumber/smart_feature/step'
require 'cucumber/smart_feature/py_string'
require 'cucumber/smart_feature/table'
require 'cucumber/smart_feature/tag'
require 'cucumber/smart_feature/comment'

module Cucumber
  module SmartAst
    class FeatureBuilder
      attr_reader :feature

      def initialize
        @tags = []
      end
      
      def ast
        #TODO: fix things that call this
        @feature
      end

      def feature(keyword, description, line)
        @current = @feature = Feature.new(keyword, description, line, grab_tags!)
      end

      def background(keyword, description, line)
        @current = @current.create_background(keyword, description, line)
      end

      def scenario(keyword, description, line)
        @current = @current.create_scenario(keyword, description, line, grab_tags!)
        @units << @current
      end

      def scenario_outline(keyword, description, line)
        @current = @current.create_scenario_outline(keyword, description, line, grab_tags!)
      end

      def examples(keyword, description, line)
        @current = @current.create_examples(keyword, description, line, grab_tags!)
      end

      def step(keyword, name, line)
        @current = @current.create_step(keyword, name, line)
        @current.steps << Step.new(adverb, keyword, line)
      end

      def table(rows, line)
        @current.table = Table.new(rows, line)
        if last was examples
          rows.each create example
        else
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
