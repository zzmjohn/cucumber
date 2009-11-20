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
      end
      
      it "should have one scenario for each table row" do
        examples = Examples.new("Examples", "Cucumber actions", 4)
        examples.steps = @steps
        examples.table(@table, 5)
        examples.should have(2).scenarios
      end
    end
  end
end