require File.dirname(__FILE__) + '/../../spec_helper'
require 'gherkin'
require 'gherkin/i18n'
require 'cucumber/smart_ast/builder'

module Cucumber
  module SmartAst
    module SpecHelper
      def build_defined_feature
        parser = ::Gherkin::Parser.new(builder, true, "root")
        lexer = ::Gherkin::I18nLexer.new(parser)
        lexer.scan(feature_content)
      end
      
      def builder
        @builder ||= Builder.new
      end
    end
    
    module SpecHelperDsl
      def define_feature(content)
        self.class_eval(%{def feature_content;"#{content}";end})
      end
    end
  end
end