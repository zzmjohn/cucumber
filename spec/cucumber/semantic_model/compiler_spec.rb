require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/semantic_model/compiler'
require 'cucumber/semantic_model/root_node'

module Cucumber
  module SemanticModel
    describe Compiler do
      it "should have a RootNode upon creation" do
        c = Compiler.new(mock(StepMother))
        c.root.should be_instance_of(RootNode)
      end
    end
  end
end
