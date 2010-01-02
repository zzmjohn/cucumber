require 'cucumber/ast/tags'
require 'cucumber/smart_ast/step_result'
require 'cucumber/smart_ast/unit_result'
require 'cucumber/smart_ast/listeners_broadcaster'

module Cucumber
  module SmartAst
    module Unit 
      attr_reader :steps, :language, :scenario

      def initialize(scenario)
        @scenario = scenario
        @language = scenario.language
        @steps    = scenario.all_steps
        @tags     = scenario.all_tags.map { |tag| "@#{tag.name}" }
        @statuses = {}
      end
      
      def accept_hook?(hook)
        Cucumber::Ast::Tags.matches?(@tags, hook.tag_name_lists)
      end
      
      def status
        @statuses.values.last # Not really right, but good enough for now
      end
      
      def fail!(exception)
        raise exception
      end
      
      def execute(run)
        run.before_unit(self)

        steps.each do |step|
          run.before_step(step)
          
          result = execute_step(step, step_mother)
          @statuses[step] = result.status
          
          skip_step_execution! if result.failure?
          
          run.after_step(result)
        end
        
        unit_result = UnitResult.new(self, @statuses)

        run.after_unit(unit_result)
      end
      
      private
      
      def skip_step_execution!
        @skip = true
      end

      def execute_step(step, step_mother)
        return StepResult.new(:skipped, step, self) if @skip
        step_mother.execute(step, self)
      end
    end
  end
end
