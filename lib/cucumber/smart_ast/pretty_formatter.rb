module Cucumber
  module SmartAst
    class PrettyFormatter
      include Formatter::ANSIColor
      def initialize(_,io,__)
        @io = io
      end
      
      def before_unit(unit)
        scenario = unit.scenario
        
        if @current_feature != scenario.feature
          print_feature(scenario.feature)
        end
        
        if scenario.outline?
          if scenario.outline != @current_scenario_outline
            @current_scenario_outline = scenario.outline
            @io.puts
            @io.puts indent(2, heading(@current_scenario_outline))

            # random thought- should scenaro outlines have steps or something else,
            # maybe 'lines?'
            @io.puts colorize(indent(4, @current_scenario_outline.steps.join("\n")), :skipped)
          end
        else
          @io.puts
          @io.puts "  " + heading(scenario)
        end
      end
      
      def after_step(result)
        @io.puts indent(4, colorize(result.step.name, result.status))
      end
      
      def after_scenario(scenario)
        @io.puts
      end
      
      private
      
      def print_feature(feature)
        @io.puts heading(feature)
        @io.puts indent(2, feature.preamble)
      end
      
      def indent(count, string)
        padding = " " * count
        string.split("\n").map{ |line| "#{padding}#{line}" }.join("\n")
      end
      
      def heading(element)
        "#{element.kw}: #{element.title}"
      end
      
      def colorize(string, status)
        case status
        when :passed
          green(string)
        when :pending || :undefined
          yellow(string)
        when :skipped
          cyan(string)
        when :failed
          red(string)
        else
          grey(string)
        end
      end
    end
  end
end