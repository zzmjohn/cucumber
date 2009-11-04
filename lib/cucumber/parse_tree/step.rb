module Cucumber
  module ParseTree
    class Step
      attr_reader :keyword, :name, :line
      
      def initialize(keyword, name, line)
        @keyword, @name, @line = keyword, name, line
      end

      def table(raw, line)
      end

      def py_string(string, line, col)
      end

      def clone_from_cells(cells)
        delimited_arguments = delimit_argument_names(cells.to_hash)
        name                = replace_name_arguments(delimited_arguments)
        Step.new(@keyword, name, cells.line)
      end

      def invoke(step_mother, scenario)
        step_match = step_mother.step_match(name, name)
        step_match.invoke(nil)
      end

      private

      def delimit_argument_names(argument_hash)
        argument_hash.inject({}) { |h,(name,value)| h[delimited(name)] = value; h }
      end

      def delimited(s)
        "<#{s}>"
      end

      def replace_name_arguments(argument_hash)
        name_with_arguments_replaced = @name
        argument_hash.each do |name, value|
          value ||= ''
          name_with_arguments_replaced = name_with_arguments_replaced.gsub(name, value)
        end
        name_with_arguments_replaced
      end

    end
  end
end
