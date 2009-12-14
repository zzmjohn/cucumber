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
    
    describe Builder do
      include SpecHelper
      extend SpecHelperDsl
      
      before(:each) do
        build_defined_feature
      end
    
      describe "for a Feature with a single scenario" do
        define_feature <<-FEATURE
          Feature: Getting things done
            Scenario: Do some stuff
              Given I am ready to do stuff
              When I do some stuff
              Then I should be in the pub celebrating
        FEATURE
        
        it { builder.ast.should_not be_nil }
        
        describe "#ast" do
          before(:each) do 
            @feature = @builder.ast 
          end

          it { @feature.should_not be_nil }
          it { @feature.should be_instance_of(Cucumber::SmartAst::Feature) }
          it { @feature.scenarios.length.should == 1 }
          
          describe "the scenario" do
            before(:each) { @scenario = @feature.scenarios.first }
            
            it { @scenario.description.should == "Do some stuff" }
            it "should have 3 steps" do
              @scenario.steps.length.should == 3
            end
          end
        end

      end
    end
  end
end