module Cucumber
  module SmartAst
    class PrettyFormatter
      def initialize(_,io,__)
        @io = io
      end
      
      def before_feature(feature)
        @io.puts heading(feature)
        @io.puts indent(2, feature.preamble)
      end
      
      def before_scenario(scenario)
        if scenario.from_outline?
          if scenario.parent != @current_scenario_outline
            @current_scenario_outline = scenario.parent
            @io.puts
            @io.puts indent(2, heading(@current_scenario_outline))
            # random thought- should scenaro outlines have steps or something else,
            # maybe 'lines?'
            @io.puts indent(4, @current_scenario_outline.steps.join("\n")) 
          end
        else
          @io.puts
          @io.puts "  " + heading(scenario)
        end
      end
      
      def after_scenario(scenario)
        @io.puts
      end
      
      private
      
      def indent(count, string)
        padding = " " * count
        string.split("\n").map{ |line| "#{padding}#{line}" }.join("\n")
      end
      
      def heading(element)
        "#{element.kw}: #{element.title}"
      end
    end
  end
end