module Cucumber
  module SmartAst
    class PrettyPrinter
      module Printer
        include Formatter::ANSIColor

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
      
      module TablePrinter
        def print_array(rows, &block)
          pad(rows, &block).each do |row|
            print_table_row(row)
          end
        end

        def print_table_row(row)
          row_string = ([''] + row + ['']).join(' | ').strip
          @io.puts indent(6, row_string)
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
      end
      
      class ExamplesPrinter
        include Printer
        include TablePrinter
        
        def initialize(io, examples)
          @io, @examples = io, examples
        end
        
        def print_heading
          @io.puts
          @io.puts indent(4, heading(@examples))

          table = @examples.table.raw

          header_row = pad([table[0]], table) { |cell| colorize(cell, :skipped) }
          print_table_row(header_row)
        end
        
        def print_row(unit_result)
          args = []
          statuses = []
          unit_result.steps.each do |step| 
            step.interpolated_args.each do |arg|
              args << arg
              statuses << unit_result.step_result(step)
            end
          end
          
          row = pad([args], @examples.table.raw) do |cell|
            colorize(cell, :passed) # TODO: real status
          end

          print_table_row(row)
        end
        
      end
      
      include Printer
      include TablePrinter
      
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

      def after_example(unit_result)
        @examples_printer.print_row(unit_result)
      end

      def examples_table(examples)
        @examples_printer = ExamplesPrinter.new(@io, examples)
        @examples_printer.print_heading
      end
      
      def example_step_result(step_result)
      end
      
      def scenario_step_result(step_result)
        @io.puts indent(4, colorize(step_result.step.to_s, step_result.status))
        step_result.step.accept_for_argument(self)
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
      
      def py_string(py_string)
        @io.puts indent(6, %{"""})
        @io.puts indent(6, py_string.to_s)
        @io.puts indent(6, %{"""})
      end

      def step_table(table)
        print_array(table.raw)
      end

    end
  end
end