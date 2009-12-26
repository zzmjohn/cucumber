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
          @current_feature = scenario.feature
          print_feature(scenario.feature)
        end
        
        if scenario.outline?
          if scenario.outline != @current_scenario_outline
            @current_scenario_outline = scenario.outline
            print_scenario_outline(scenario.outline)
          end
        else
          print_scenario(scenario)
        end
      end
      
      def after_step(result)
        step_name = @io.tty? ? self.__send__(result.status, result.step.to_s) : result.step.to_s
        @io.puts indent(4, step_name)
        result.step.visit_argument(self)
      end
      
      def after_scenario(scenario)
        @io.puts
      end
      
      def visit_py_string(py_string)
        @io.puts indent(6, %{"""})
        @io.puts indent(6, py_string.to_s)
        @io.puts indent(6, %{"""})
      end
      
      def visit_step_table(table)
        rows = table.raw
        max_lengths =  rows.transpose.map { |col| col.map { |cell| cell.unpack("U*").length }.max }.flatten
        rows.each do |table_line|
          @io.puts '      | ' + table_line.zip(max_lengths).map { |cell, max_length| cell + ' ' * (max_length-cell.unpack("U*").length) }.join(' | ') + ' |'
        end
      end
      
      private
      
      def print_feature(feature)
        @io.puts heading(feature)
        @io.puts indent(2, feature.preamble)
      end
      
      def print_scenario_outline(outline)
        @io.puts
        @io.puts indent(2, heading(outline))

        # random thought- should scenaro outlines have steps or something else,
        # maybe 'lines?'
        @io.puts colorize(indent(4, outline.steps.join("\n")), :skipped)
      end
      
      def print_scenario(scenario)
        @io.puts
        @io.puts "  " + heading(scenario)
      end
      
      def indent(count, string)
        padding = " " * count
        string.split("\n").map{ |line| "#{padding}#{line}" }.join("\n")
      end
      
      def heading(element)
        "#{element.keyword}: #{element.title}"
      end
    end
  end
end