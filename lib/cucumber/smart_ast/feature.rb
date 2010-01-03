require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/scenario'
require 'cucumber/smart_ast/scenario_outline'
require 'cucumber/smart_ast/description'
require 'cucumber/smart_ast/unit'

module Cucumber
  module SmartAst
    class Feature
      include Tags
      include Description

      attr_accessor :language, :keyword

      def initialize(keyword, description, line, tags)
        @keyword, @description, @line = keyword, description, line
        @tags = tags
      end
      
      def create_background(keyword, description, line)
        @background = StepContainer.new(keyword, description, line, self)
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
      
      def background_steps
        @background ? @background.steps : []
      end
    end
  end
end
