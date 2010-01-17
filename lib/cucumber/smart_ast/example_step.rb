module Cucumber
  module SmartAst
    # Step generated from StepTemplate
    class ExampleStep
      # TODO: Better if this has ref to StepTemplate!!
      def initialize(step_template, example_cells)
        @step_template, @example_cells = example, example_cells
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