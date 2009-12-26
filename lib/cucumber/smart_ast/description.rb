module Cucumber
  module SmartAst
    module Description
      def title
        @description.split("\n").first
      end

      def preamble
        description_lines = @description.split("\n")
        description_lines.shift
        description_lines.join("\n")
      end
    end
  end
end
