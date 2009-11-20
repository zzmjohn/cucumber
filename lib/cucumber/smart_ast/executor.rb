module Cucumber
  module SmartAst
    class Executor
      def initialize(step_mother)
        @step_mother = step_mother
      end

      def execute(ast)
        background = ast.bg
        ast.scenarios.each do |scenario|
          @step_mother.before_and_after(scenario) do 
            if background
              background.steps.each { |step| invoke(step) }
            end
            scenario.steps.each { |step| invoke(step) }
          end
        end
        
        ast.scenario_outlines.each do |scenario_outline|
          scenario_outline.each do |examples|
            examples.scenarios.each do |scenario|
              @step_mother.before_and_after(scenario) do
                if background
                  background.steps.each { |step| invoke(step) }
                end
                scenario.steps.each { |step| invoke(step) }
              end
            end
          end
        end
      end
      
      def invoke(step)
        puts "Invoking #{step.to_s}"
        if step.argument
          @step_mother.invoke(step.name, step.argument.to_s)
        else
          @step_mother.invoke(step.name)
        end
      end
    end
  end
end
