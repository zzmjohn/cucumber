module Cucumber
  module SmartAst
    class Step
      attr_accessor :argument
      attr_reader :adverb, :name, :line
      
      def initialize(adverb, name, line)
        @adverb, @name, @line = adverb, name, line
      end
      
      def interpolate(args)
        name = @name.dup
        args.each_pair { |k, v| name.gsub!(/<#{k}>/, v) }
        step = new(@adverb, name, @line)
        step.argument = @argument if @argument
        step
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
