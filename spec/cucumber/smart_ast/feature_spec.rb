require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/feature'

module Cucumber
  module SmartAst
    describe Feature do
      it "should return all units in physical order"
      it "should include the background steps in each unit"
      it "should expand scenario outline examples into units"
    end
  end
end