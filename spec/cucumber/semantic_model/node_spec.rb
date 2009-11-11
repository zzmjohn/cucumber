require File.dirname(__FILE__) + '/../../spec_helper'

module Cucumber
  module SemanticModel
    describe "Node" do

      shared_examples_for "a Semantic Model Node" do
        describe "interface" do
          it "should respond to children" do
            @sm_node.should respond_to(:children)
          end

          it "should respond to add_child" do
            @sm_node.should respond_to(:add_child)
          end
 
          it "should respond to announce" do
            @sm_node.should respond_to(:announce)
          end

          it "should respond to invoke" do
            @sm_node.should respond_to(:invoke)
          end

          it "should respond to accept" do
            @sm_node.should respond_to(:accept)
          end

          it "should respond to parent" do
            @sm_node.should respond_to(:parent)
          end
        end
       
        describe "adding children" do
          it "should allow adding children and return them when asked for" do
            child = mock("Node").as_null_object
            @sm_node.add_child(child)
            @sm_node.children.should include(child)           
          end

          it "should return the children in the order they were added" do
            child1 = mock("Node").as_null_object
            child2 = mock("Node2").as_null_object
            @sm_node.add_child(child1)
            @sm_node.add_child(child2)
            @sm_node.children.first.should == child1
            @sm_node.children.last.should == child2 
          end
        end
      end
    end
  end
end
