module Cucumber
  module SmartAst
    class Result
      attr_reader :status, :step

      def initialize(status, step)
        @status, @step = status, step
      end

      def to_s
        "#{status.to_s.capitalize}: #{step} on line #{step.line}"
      end

      def failure?
        [:undefined, :pending, :failed].include?(@status)
      end
    end
  end
end
