require 'cucumber/smart_ast/comment'

module Cucumber
  module SmartAst
    module Comments
      attr_reader :comments
      def comment(comment, line)
        @comments ||= []
        comment = Comment.new(comment, line)
        @comments << comment
        comment
      end
    end
  end
end
