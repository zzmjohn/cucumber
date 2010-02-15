module Cucumber
  module SmartAst
    class StepResult
      def initialize(unit_result, step)
        @unit_result, @step = unit_result, step
        @status = :skipped
        @exception = nil
        @arguments = nil
      end

      def execute(step_mother, step_name, multiline_argument)
        multiline_argument = multiline_argument.to_execution_format unless multiline_argument.nil?
        begin
          @step_match = step_mother.step_match(step_name)
          @arguments = @step_match.step_arguments
          @step_match.invoke(multiline_argument)
          status!(:passed)
        rescue Undefined
          status!(:undefined)
        rescue Pending
          status!(:pending)
        rescue Exception => ex
          status!(:failed, ex)
        end
      end

      def accept(visitor)
        visitor.visit_step_result(self)
      end

      def report_to(gherkin_listener)
        @step.report_result(gherkin_listener, @status, @arguments, (@step_match || @step).file_colon_line, @exception)
      end

      private

      def status!(status, exception=nil)
        @status = status
        @exception = exception
        @unit_result.status!(status, exception)
      end

    end
  end
end
