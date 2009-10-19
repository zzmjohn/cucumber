module Cucumber
  module Asg
    # Builds an Asg by walking the Ast
    class Builder
      def visit_feature(feature)
        @background_steps = []
        feature.accept(self)
      end

      def visit_background(background)
        @steps = @background_steps
        background.accept(self)
      end

      def visit_element(element)
        @steps = []
        element.accept(self)
        all_steps = @background_steps + @steps
        puts "-------"
        puts all_steps.map{|s| s.name}
      end

      def visit_step(step)
        @steps << step
      end
    end
  end
end