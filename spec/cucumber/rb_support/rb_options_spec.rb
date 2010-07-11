require 'spec_helper'
require 'cucumber/rb_support/rb_options'

module Cucumber
  module RbSupport
    describe Options do
      before(:each) do
        @options = Options.new
      end

      context "option with an argument" do
        it "should generate a list containing command and argument" do
          @options.format = 'pretty'

          @options.list.should == ['--format', 'pretty']
        end
      end

      context "option with a true argument" do
        it "should not show the true flag in the list of command line options" do
          @options.wip = true

          @options.list.should == ['--wip']
        end
      end

      context "option with a false boolean argument" do
        it "should not add the option to the list of command line options" do
          @options.wip = false

          @options.list.should == []
        end
      end

    end
  end
end
