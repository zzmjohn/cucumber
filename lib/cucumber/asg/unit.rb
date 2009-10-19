module Cucumber
  module Asg
    # A Unit represents the execution of a Scenario or a row in a Scenario Outline Table
    class Unit
      def initialize(scenario, invocations)
        @invocations = invocations
      end

      def execute(step_mother, options, notifier)
        # execute Before, Background, Steps, After
        @invocations.each do |invocation|
          invocation.invoke_and_notify(step_mother, options, notifier)
        end
      end
    end
  end
end