require File.dirname(__FILE__) + '/../spec_helper'

require 'cucumber'

module Cucumber
  describe FeatureLoader do
    before do
      @out = StringIO.new
      @log = Logger.new(@out)
      @feature_loader = FeatureLoader.new
      @feature_loader.log = @log
    end
    
    it "should have English adverbs by default" do
      @feature_loader.adverbs.should == ["Given", "When", "Then", "And", "But"]
    end
    
    it "should have other adverbs if other languages are used"
    
    it "should load feature sources and return a feature suite" do
      pending
      @feature_loader.load_features("example.feature")
    end
    
    it "should split the content name and line numbers from the sources" do
      Inputs::File.should_receive(:new).with("example.feature").and_return(mock("file input").as_null_object)
      Builders::Gherkin.stub!(:new).and_return(mock("gherkin builder").as_null_object)
      @feature_loader.load_features("example.feature:10:20")
    end
  end
end