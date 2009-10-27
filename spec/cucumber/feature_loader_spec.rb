require File.dirname(__FILE__) + '/../spec_helper'

require 'cucumber'

module Cucumber
  describe FeatureLoader do
    before do
      @out = StringIO.new
      @log = Logger.new(@out)

      @feature_loader = FeatureLoader.new
      @feature_loader.log = @log

      @file_input = mock('file input service', :read => "Feature: test", :protocols => [:file])
      @feature_loader.register_input(@file_input)
      @gherkin_parser = mock('gherkin parser', :adverbs => ["Given"], :parse => mock('feature', :features= => true))
      @feature_loader.register_parser(@gherkin_parser)
    end
    
    it "should load a feature from a file" do
      @file_input.should_receive(:read).with("example.feature").once
      @gherkin_parser.should_receive(:parse).once
      @feature_loader.load_feature("example.feature")
    end

    it "should load a feature from a file with spaces in the name" do
      @file_input.should_receive(:read).with("features/spaces are nasty.feature").once
      @feature_loader.load_feature("features/spaces are nasty.feature")
    end
    
    it "should load features from multiple input sources" do
      http_input = mock('http input service', :read => "Feature: test", :protocols => [:http])
      http_input.should_receive(:read).with("http://test.domain/http.feature").once
      @file_input.should_receive(:read).with("example.feature").once

      @feature_loader.register_input(http_input)
      @feature_loader.load_features(["example.feature", "http://test.domain/http.feature"])
    end
    
    it "should alias each protocol from the input source" do
      @feature_loader.register_input(mock('http', :protocols => [:http, :https]))
      @feature_loader.protocols.should include(:http, :https)
    end
    
    it "should raise if it has no input service for the protocol" do
      lambda {
       @feature_loader.load_feature("accidentally://the.whole/thing.feature") 
      }.should raise_error(InputServiceNotFound, /.*'accidentally'.*Services available:.*/)
    end

    it "should split the content name and line numbers from the sources" do
      @file_input.should_receive(:read).with("example.feature")
      @feature_loader.load_feature("example.feature:10:20")
    end

    it "should have English adverbs by default" do
      @feature_loader.adverbs.should == ["Given", "When", "Then", "And", "But"]
    end
    
    it "should have other adverbs if other languages are used" do
      pending
      # given builder loads fr-parser
      # feature_loader.adverbs.should include(french adverbs)
    end
     
    it "should take a hint from the input when determining what builder to use" do
      pending
      # input.format = :json
      # Parsers::JSON.should_receive(:new)
      # @feature_loader.load_features("http://domain.com/my.feature")
    end
    
    it "should load feature sources and return a feature suite" do
      pending
      @feature_loader.load_features("example.feature")
    end    
  end
end
