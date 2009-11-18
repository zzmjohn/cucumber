module Cucumber
  module SmartAst
    class Feature
      def feature(name, description, line)
        @name, @description, @line
      end

      def background(background)
        @background = background
      end

      def scenario(scenario)
        @scenarios << scenario
      end

      def scenario_outline(scenario_outline)
        @scenario_outlines << scenario_outline
      end

      def examples(examples)
        @scenario_outlines.last.examples(examples)
      end
    end
  end
end
