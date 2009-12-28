module Cucumber
  module SmartAst
    class PrettyFormatter
      class PrettyPrinter
        include Formatter::ANSIColor
        
        def initialize(io)
          @io = io
        end

        def feature(feature)
          if @seen_first_feature
            @io.puts
          end
          @seen_first_feature = true

          @io.puts heading(feature)
          @io.puts indent(2, feature.preamble)
        end
        
        def examples_table_step_result(result)
          # TODO: table should be passed into this method, rather than held in state
          cells = pad([result.step.interpolated_arguments], @examples.table.raw) do |cell|
            colorize(cell, result.status)
          end.flatten

          @io.print " | #{cells.join(' | ')}"
        end
        
        def begin_examples_table_row
          @io.print indent(5)
        end
        
        def end_examples_table_row
          @io.puts " |"
        end
        
        def scenario_step_result(result)
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
          @examples = examples
          @io.puts
          @io.puts indent(4, heading(examples))
          array([examples.table.raw[0]]) do |cell|
            colorize(cell, :skipped)
          end # TODO: this won't work if the rows contain wider cols than the headers
        end
        
        def py_string(py_string)
          @io.puts indent(6, %{"""})
          @io.puts indent(6, py_string.to_s)
          @io.puts indent(6, %{"""})
        end

        def step_table(table)
          array(table.raw)
        end

        private
        
        def array(rows, &block)
          pad(rows, &block).each do |row|
            row_string = ([''] + row + ['']).join(' | ').strip
            @io.puts indent(6, row_string)
          end
        end
        
        def pad(cells, whole_array = nil)
          whole_array ||= cells
          cells.map do |row|
            row.zip(col_widths(whole_array)).map do |cell, col_width|
              padding = ' ' * (col_width - true_length(cell))
              cell = yield(cell) if block_given?
              cell + padding
            end
          end
        end
        
        def col_widths(array)
          array.transpose.map do |col| 
            col.map{ |cell| true_length(cell) }.max
          end.flatten
        end
        
        def true_length(string)
          string.unpack("U*").length
        end
        
        def indent(count, string = '')
          padding = " " * count
          return padding if string.empty?
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
        
        if @scenario.from_outline?
          on_new_scenario_outline do |scenario_outline|
            @printer.scenario_outline(scenario_outline)
          end
          
          on_new_examples_table do |examples_table|
            @printer.examples_table(examples_table)
          end
          
          @printer.begin_examples_table_row
        else
          @printer.scenario(@scenario)
        end
      end
      
      def after_step(result)
        result.accept(@printer)
      end
      
      def after_unit(result)
        @printer.end_examples_table_row if @scenario.from_outline?
      end
      
      private

      def on_new_feature
        if @feature != @scenario.feature
          @feature = @scenario.feature
          yield @feature
        end
      end
      
      def on_new_scenario_outline
        if @scenario_outline != @scenario.outline
          @scenario_outline = @scenario.outline
          yield @scenario_outline
        end
      end
      
      def on_new_examples_table
        if @examples_table != @scenario.examples
          @examples_table = @scenario.examples
          yield @examples_table
        end
      end

    end
  end
end