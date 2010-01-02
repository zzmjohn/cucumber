require File.dirname(__FILE__) + '/builder_spec_helper'

module Cucumber
  module SmartAst
    describe FeatureBuilder do
      include SpecHelper
      extend SpecHelperDsl
      
      before(:each) do
        build_defined_feature
        @feature = builder.result[0]
        @units = builder.result[1]
      end
    
      describe "for a Feature with a single scenario" do
        define_feature <<-FEATURE
          Feature: Getting things done
            Scenario: Do some stuff
              Given I am ready to do stuff
              When I do some stuff
              Then I should be in the pub celebrating
        FEATURE
        
        it { @feature.should_not be_nil }
        it { @feature.should be_instance_of(Cucumber::SmartAst::Feature) }
        it { @units.length.should == 1 }
        
        describe "the scenario" do
          before(:each) { @scenario = @units.first }
          
          it { @scenario.description.should == "Do some stuff" }
          it "should have 3 steps" do
            @scenario.steps.length.should == 3
          end
        end
      end
      
      describe "a feature with a scenario outline" do
        define_feature <<-FEATURE
          Feature: Getting things done
            Scenario Outline: Do some stuff
              Given I am ready to do stuff
              When I do <What I do>
              Then I should be in the pub celebrating
              
              Examples:
              | What I do     |
              | open my post  |
              | pay the bills |
        FEATURE
        
        it { @units.length.should == 2 }
      end
    end
  end
end