require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/unit'

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
      
      def units
        all_scenarios = scenarios.collect do |scenario|
          Unit.new(scenario.steps, scenario.language)
        end
        
        # TODO: Stop touching the parse tree inappropriately
        scenario_outlines.each do |scenario_outline|
          scenario_outline.each do |examples|
            examples.scenarios.each do |scenario|
              all_scenarios << Unit.new(scenario.steps, scenario.language)
            end
          end
        end
        
        all_scenarios
      end
    end
  end
end
