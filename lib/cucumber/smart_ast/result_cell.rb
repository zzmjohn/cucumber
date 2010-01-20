module Cucumber
  module SmartAst
    class ResultCell
      def initialize(key, value)
        @key, @value = key, value
      end

      def attach(name, argument, step_result)
        if name =~ /<#{@key}>/
          name.gsub!(/<#{@key}>/, @value)
          step_result.add_cell(self)
        end

        if argument && argument.gsub!(@key, @value)
          step_result.add_cell(self)
        end
      end
    end
  end
end