require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class Feature
      include Tags
      include Description

      attr_accessor :language, :features, :background, :keyword
      attr_reader :scenarios, :scenario_outlines

      def initialize(keyword, description, line, tags)
        @keyword, @description, @line = keyword, description, line
        @tags = tags
      end
      
      def create_background(keyword, description, line)
        StepContainer.new(keyword, description, line, self)
      end
      
      def create_scenario(keyword, description, line, tags)
        Scenario.new(keyword, description, line, tags, self)
      end
      
      def create_scenario_outline(keyword, description, line, tags)
        ScenarioOutline.new(keyword, description, line, tags, self)
      end
      
      def adverbs
        @language.adverbs
      end
      
      def units
        all_scenarios
      end

      def background_steps
        background ? background.steps : []
      end
      
      private
      
      def all_scenarios
        return @all_scenarios if @all_scenarios
        @all_scenarios = scenarios 
        @all_scenarios += scenario_outlines.collect { |outline| outline.scenarios }
        @all_scenarios = @all_scenarios.flatten
      end

    end
  end
end
