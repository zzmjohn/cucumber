require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/smart_ast/tag'

module Cucumber
  module SmartAst
    describe Tag do
      it "should equate to another tag of the same name" do
        Tag.new("foo",1).should == Tag.new("foo",2)
      end
      
      it "should not equate to another tag of a different name" do
        Tag.new("foo",1).should_not == Tag.new("bar",1)
      end
    end
  end
end