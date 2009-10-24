module Cucumber
  module Asg
    class CompiledFeature
      def initialize
        @compiled_scenarios = []
      end
      
      def add_unit(compiled_scenario)
        @compiled_scenarios << compiled_scenario
      end

      def accept(visitor)
        @compiled_scenarios.each do |compiled_scenario|
          visitor.visit_scenario(compiled_scenario)
        end
      end
    end
  end
end