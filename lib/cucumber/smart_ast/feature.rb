require 'cucumber/smart_ast/tags'

module Cucumber
  module SmartAst
    class Feature
      include Tags

      attr_accessor :language, :features, :background
      attr_reader :scenarios, :scenario_outlines

      def initialize
        @scenarios = []
        @scenario_outlines = []
      end

      def feature(name, description, line)
        @name, @description, @line = name, description, line
      end

      def scenario(scenario)
        @scenarios << scenario
        scenario
      end

      def scenario_outline(scenario_outline)
        @scenario_outlines << scenario_outline
        scenario_outline
      end

      def examples(examples)
        @scenario_outlines.last.examples(examples)
      end

      def name
        "#{@name}: #{@description}"
      end
      
      def adverbs
        @language.adverbs
      end

      def all_scenarios
        return @all_scenarios if @all_scenarios
        @all_scenarios = scenarios 
        @all_scenarios += scenario_outlines.collect { |outline| outline.scenarios }
        @all_scenarios = @all_scenarios.flatten
      end

      def background_steps
        background ? background.steps : []
      end
    end
  end
end
