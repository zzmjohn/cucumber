module Cucumber
  module SmartAst
    class PrettyFormatter
      class PrettyPrinter
        include Formatter::ANSIColor
        
        def initialize(io)
          @io = io
        end

        def feature(feature)
          @io.puts heading(feature)
          @io.puts indent(2, feature.preamble)
        end
        
        def step_result(result)
          @io.puts indent(4, colorize(result.step.to_s, result.status))
          result.step.accept_for_argument(self)
        end
        
        def scenario(scenario)
          @io.puts
          @io.puts indent(2, heading(scenario))
        end
        
        def scenario_outline(outline)
          @io.puts
          @io.puts indent(2, heading(outline))

          # random thought- should scenaro outlines have steps or something else,
          # maybe 'lines?'
          @io.puts indent(4, colorize(outline.steps.join("\n"), :skipped))
        end
        
        def examples_table(examples)
          @io.puts
          @io.puts indent(4, heading(examples))
          step_table examples.table # hack - just print header
        end
        
        def py_string(py_string)
          @io.puts indent(6, %{"""})
          @io.puts indent(6, py_string.to_s)
          @io.puts indent(6, %{"""})
        end

        def step_table(table)
          rows = table.raw
          max_lengths =  rows.transpose.map { |col| col.map { |cell| cell.unpack("U*").length }.max }.flatten
          rows.each do |table_line|
            @io.puts '      | ' + table_line.zip(max_lengths).map { |cell, max_length| cell + ' ' * (max_length-cell.unpack("U*").length) }.join(' | ') + ' |'
          end
        end

        private
        
        def indent(count, string)
          padding = " " * count
          string.split("\n").map{ |line| "#{padding}#{line}" }.join("\n")
        end

        def colorize(string, status)
          return string unless @io.tty?
          self.__send__(status, string)
        end

        def heading(element)
          "#{element.keyword}: #{element.title}"
        end
        
      end
      
      def initialize(_,io,__)
        @printer = PrettyPrinter.new(io)
      end
      
      def before_unit(unit)
        @scenario = unit.scenario
        
        on_new_feature do |feature|
          @printer.feature(feature)
        end
        
        if @feature != @scenario.feature
          @feature = @scenario.feature
          @printer.feature(@scenario.feature)
        end
        
        if @scenario.outline?
          if @scenario_outline != @scenario.outline
            @scenario_outline = @scenario.outline
            @printer.scenario_outline(@scenario_outline)
          end
          
          if @examples != @scenario.examples
            @examples = @scenario.examples
            @printer.examples_table(@examples)
          end
        else
          @printer.scenario(@scenario)
        end
      end
      
      def after_step(result)
        return if @scenario.outline?
        @printer.step_result(result)
      end
      
      private
      

      def on_new_feature
        if @feature != @scenario.feature
          @feature = @scenario.feature
          yield @feature
        end
      end
      
    end
  end
end