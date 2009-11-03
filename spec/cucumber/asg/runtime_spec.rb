require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/new_ast/step'
require 'cucumber/asg/runtime'
require 'cucumber/step_mother'

module Cucumber
  module Asg
    describe Runtime do
      before do
        step_mother = StepMother.new
        @rb = step_mother.load_programming_language('rb')
        @runtime = Runtime.new(step_mother)
      end

      it "should invoke a step definition" do
        step = NewAst::Step.new("Given", "I have 5 cukes in my belly", 9)
        matched_cukes = nil
        @rb.register_rb_step_definition(/I have (.*) cukes in my belly/, lambda {|cukes| matched_cukes = cukes})
        @runtime.visit_statement(step)
        matched_cukes.should == "5"
      end

      it "should invoke a before hook" do
        pending("******************* Next place to pick up, Aslak!") do
          kilroy = nil
          hook = @rb.register_rb_hook(:before, [], lambda {kilroy})
          @runtime.visit_statement(hook)
          kilroy.should == "was here"
        end
      end
    end
  end
end
