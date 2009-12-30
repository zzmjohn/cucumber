module Cucumber
  module SmartAst
    class Step
      attr_accessor :argument
      attr_reader :adverb, :name, :line, :interpolated_args
      
      def initialize(adverb, name, line, container, interpolated_args = [])
        @adverb, @name, @line, @container, @interpolated_args = adverb, name, line, container, interpolated_args
      end
      
      def interpolate(args, headers)
        name = @name.dup
        matched_args = []
        headers.each do |key|
          value = args[key]
          if name =~ /<#{key}>/
            name.gsub!(/<#{key}>/, value)
            matched_args << value
          end
        end
        step = self.class.new(@adverb, name, @line, matched_args)
        step.argument = @argument if @argument
        step
      end
      
      def accept_for_argument(visitor)
        argument.accept(visitor) if argument
      end
      
      def to_execution_format
        [@name, @argument ? @argument.to_execution_format : nil]
      end
      
      def ==(obj)
        @name == obj.name
      end
      
      def to_s
        "#{@adverb} #{@name}"
      end
    end
  end
end
