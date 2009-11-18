require 'cucumber/smart_ast/feature'

module Cucumber
  module SmartAst
    class Builder
      attr_reader :ast

      def initialize
        @current = @ast = Feature.new
      end

      def feature(name, description, line)
        @current.feature(name, description, line)
      end
    end
  end
end
