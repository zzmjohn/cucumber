module Cucumber
  module SmartAst
    class Step
      attr_accessor :argument
      attr_reader :adverb, :name, :line, :interpolated_arguments
      
      def initialize(adverb, name, line, interpolated_arguments = [])
        @adverb, @name, @line, @interpolated_arguments = adverb, name, line, interpolated_arguments
      end
      
      def interpolate(args)
        name = @name.dup
        matched_args = []
        args.each_pair do |key, value| 
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
