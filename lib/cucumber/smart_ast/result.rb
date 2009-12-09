module Cucumber
  module SmartAst
    class Result
      attr_reader :status, :step

      def initialize(status, step, exception=nil)
        @status, @step, @exception = status, step, exception
      end

      def to_s
        msg = "#{status.to_s.capitalize}: #{step} on line #{step.line}"
        msg += " #{@exception.to_s}" if @exception
        msg
      end

      def failure?
        [:undefined, :pending, :failed].include?(@status)
      end
    end
  end
end
