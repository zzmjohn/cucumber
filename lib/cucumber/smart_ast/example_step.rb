module Cucumber
  module SmartAst
    # Step generated from StepTemplate
    class ExampleStep
      def initialize(example, name, argument)
        @example, @name, @argument = example, name, argument
      end

      def execute(step_mother, listener)
        listener.before_step(self)
        e, status = step_mother.invoke2(@name, @argument)
        result = StepResult.new(status, self, e)
        listener.after_step(result)
        step_mother.after_step # TODO: Feels weird to not pass self.
      end

      def report_result(gherkin_listener, status, exception)
        @example.report_result(gherkin_listener, status, exception)
      end
    end
  end
end