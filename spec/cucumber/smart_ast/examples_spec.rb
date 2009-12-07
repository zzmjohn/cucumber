require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/examples'

module Cucumber
  module SmartAst
    describe Examples do
      before do
        @steps = [
          Step.new("Given", "I have <start> Cucumbers in my <object>", 1),
          Step.new("When", "I <action> <num> Cucumbers", 2),
          Step.new("Then", "I should have <left> Cucumbers left in my <object>", 3)
        ]
        
        @table = [
          %w(start object action num left),
          %w(10 bucket eat 5 5),
          %w(10 belly vomit 8 2)
        ]
        
        @examples = Examples.new("Examples", "Cucumber actions", 4)
        @examples.steps = @steps
        @examples.table(@table, 5)
      end
      
      it "should have one scenario for each table row" do
        @examples.should have(2).scenarios
      end
      
      it "should create scenarios corresponding to the steps and the rows" do
        @examples.scenarios.first.collect { |step| step.to_s }.should == [
          "Given I have 10 Cucumbers in my bucket",
          "When I eat 5 Cucumbers",
          "Then I should have 5 Cucumbers left in my bucket"
        ]
        
        @examples.scenarios.last.collect { |step| step.to_s }.should == [
          "Given I have 10 Cucumbers in my belly",
          "When I vomit 8 Cucumbers",
          "Then I should have 2 Cucumbers left in my belly"
        ]
      end
    end
  end
end