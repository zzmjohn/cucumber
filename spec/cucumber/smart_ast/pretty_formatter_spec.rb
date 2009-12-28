require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/smart_ast/pretty_formatter'
require 'cucumber/smart_ast/builder'
require 'cucumber/smart_ast/features'
require 'gherkin'

module Cucumber
  module SmartAst
    module FormatterSpecHelper
      def execute_features(content)
        io = StringIO.new
        formatter = PrettyFormatter.new(nil, io, nil)

        features = load_features(@feature_content)
        step_mother = StepMother.new
        features.execute(step_mother, [formatter])
        io.string
      end
      
      private
      
      def load_features(content)
        builder = Builder.new
        parser = ::Gherkin::Parser.new(builder, true, "root")
        lexer = ::Gherkin::I18nLexer.new(parser)
        lexer.scan(content)
        features = Features.new
        features << builder.ast
        features
      end
    end
    
    describe PrettyFormatter do
      include FormatterSpecHelper

      describe "a single feature with a single scenario" do
        before(:each) do
          @feature_content = <<-FEATURES
Feature: Feature Description
  Some preamble

  Scenario: Scenario Description
    Given there is a step
      """
      with
        pystrings
      """
    And there is another step
      | æ | o |
      | a | ø |
    Then we will see steps
          FEATURES
        end
        
        it "should print output identical to the gherkin input" do
          execute_features(@feature_content).should == @feature_content
        end
      end
      
      describe "a single feature with a scenario outline" do
        before(:each) do
          @feature_content = <<-FEATURES
Feature: Feature Description
  Some preamble

  Scenario Outline: Scenario Ouline Description
    Given there is a <foo>
    And <bar> <baz>

    Examples: Examples Description
      | foo  | bar | baz       |
      | step | I   | am hungry |
          FEATURES
        end
        
        it "should print output identical to the gherkin input" do
          execute_features(@feature_content).should == @feature_content
        end
        
      end
    end
  end
end