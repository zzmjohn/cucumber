require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/executor'
require 'cucumber/smart_ast/builder'

module Cucumber
  module SmartAst
    describe Executor do
      before do
        builder = Builder.new
        builder.feature("Feature", "Test execution feature", 1)

        builder.background("Background", "", 2)
        builder.step("Given", "I am in the background with a table", 3)
        builder.table([%w(1 2 3), %w(a b c)], 4)
        
        builder.scenario("Scenario", "A Scenario", 5)
        builder.step("Given", "a step", 6)

        builder.scenario("Scenario", "An other Scenario", 7)
        builder.step("Given", "an other step", 8)

        @ast = builder.ast
        @executor = Executor.new(mock("step mother"))
      end

      it "should find four steps" do
        pending "Executor doesn't do much yet"
        @executor.execute(@ast).should == 4
      end
    end
  end
end
