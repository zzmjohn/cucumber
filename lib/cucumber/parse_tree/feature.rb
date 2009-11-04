require 'cucumber/parse_tree/background'
require 'cucumber/parse_tree/scenario'
require 'cucumber/parse_tree/scenario_outline'

module Cucumber
  module ParseTree
    class Feature
      attr_writer :language, :features
      
      def initialize(keyword, name, line)
        @elements = []
      end

      def background(keyword, name, line)
        @background = Background.new(keyword, name, line)
      end

      def scenario(keyword, name, line)
        s = Scenario.new(keyword, name, line)
        @elements << s
        s
      end

      def scenario_outline(keyword, name, line)
        s = ScenarioOutline.new(keyword, name, line)
        @elements << s
        s
      end

      def accept(visitor)
        visitor.visit_background(@background) if @background
        @elements.each do |element|
          if ScenarioOutline === element
            visitor.visit_scenario_outline(element)
          else
            visitor.visit_scenario(element)
          end
        end
      end
    end
  end
end
