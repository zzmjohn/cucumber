require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/smart_ast/pretty_formatter'
require 'cucumber/smart_ast/feature_builder'
require 'cucumber/smart_ast/features'
require 'cucumber/smart_ast/run'
require 'gherkin'

module Cucumber
  module SmartAst
    module FormatterSpecHelper
      def execute_features(content)
        io = StringIO.new
        formatter = PrettyFormatter.new(nil, io, nil)
        
        units = load_units(@feature_content)

        run = Run.new([formatter])
        run.execute(units)

        io.string
      end
      
      private
      
      def load_units(content)
        builder = FeatureBuilder.new
        parser = ::Gherkin::Parser.new(builder, true, "root")
        lexer = ::Gherkin::I18nLexer.new(parser)
        lexer.scan(content)
        builder.units
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