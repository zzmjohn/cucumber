require 'cucumber/ast/tags'
require 'cucumber/smart_ast/step_result'
require 'cucumber/smart_ast/unit_result'
require 'cucumber/smart_ast/listeners_broadcaster'

module Cucumber
  module SmartAst
    module Unit
      def accept_hook?(hook)
        tags = @tags.map { |tag| "@#{tag.name}" }
        TagExpression.parse(hook.tag_expressions).eval(tags)
      end
      
      def fail!(exception)
        raise exception
      end
      
      def execute(run)
        # TODO: move onto Run
        
        run.before_unit(self)
        
        results = {}
        skip = false
        
        all_steps.each do |step|
          run.before_step(step)
        
          result = if skip
            StepResult.new(:skipped, step, self)
          else
            run.step_mother.execute(step, self)
          end
          skip = true if result.failure?
          
          results[step] = result
          
          run.after_step(result)
        end
        
        unit_result = UnitResult.new(self, results)
        run.after_unit(unit_result)
      end
      
      private
      
      def all_steps
        feature.background_steps + @steps
      end
      
    end
  end
end
