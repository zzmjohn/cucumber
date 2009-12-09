require 'cucumber/ast/tags'
require 'cucumber/smart_ast/result'

module Cucumber
  module SmartAst
    class Unit 
      attr_reader :steps, :language

      def initialize(steps, tags, language)
        @steps, @language = steps, language
        @tags = tags.map { |tag| "@#{tag.name}" }
        @statuses = []
      end
      
      def accept_hook?(hook)
        Cucumber::Ast::Tags.matches?(@tags, hook.tag_name_lists)
      end

      def status
        @statuses.last # Not really right, but good enough for now
      end
      
      def fail!(exception)
        puts "Unit failed!"
        raise exception
      end
      
      def skip_step_execution!
        @skip = true
      end

      def execute(step_mother, &block)
        step_mother.before_and_after(self) do
          steps.each do |step|
            res = if @skip
              Result.new(:skipped, step)
            else
              step_mother.execute(step)
            end
            @statuses << res.status
            yield res
          end
        end
      end
    end
  end
end
