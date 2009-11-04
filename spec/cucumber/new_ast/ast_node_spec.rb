require File.dirname(__FILE__) + '/../../spec_helper'

module Cucumber
  module NewAst
    describe "AstNode" do

      shared_examples_for "an AstNode" do
        describe "interface" do
          it "should respond to children" do
            @ast_node.should respond_to(:children)
          end

          it "should respond to add_child" do
            @ast_node.should respond_to(:add_child)
          end
 
          it "should respond to announce" do
            @ast_node.should respond_to(:announce)
          end

          it "should respond to invoke" do
            @ast_node.should respond_to(:invoke)
          end

          it "should respond to accept" do
            @ast_node.should respond_to(:accept)
          end
        end
       
        describe "adding children" do
          it "should allow adding children and return them when asked for" do
            child = mock("Node")
            @ast_node.add_child(child)
            @ast_node.children.should include(child)           
          end

          it "should return the children in the order they were added" do
            child1 = mock("Node")
            child2 = mock("Node2")
            @ast_node.add_child(child1)
            @ast_node.add_child(child2)
            @ast_node.children.first.should == child1
            @ast_node.children.last.should == child2 
          end
        end
      end
    end
  end
end
