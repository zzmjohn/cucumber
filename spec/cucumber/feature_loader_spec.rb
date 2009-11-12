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
      FeatureLoader.register_input(@file_input)
      @gherkin_parser = mock('gherkin parser', :adverbs => ["Given"], :parse => mock('feature', :features= => true), :format => :gherkin)
      @feature_loader.register_parser(@gherkin_parser)
    end

    it "should split the content name and line numbers from the sources" do
      @file_input.should_receive(:read).with("example.feature")
      @feature_loader.load_feature("example.feature:10:20")
    end
    
    it "should load a feature from a file" do
      @file_input.should_receive(:read).with("example.feature").once
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

      FeatureLoader.register_input(http_input)
      @feature_loader.load_features(["example.feature", "http://test.domain/http.feature"])
    end
    
    it "should say it supports the protocols provided by a registered input service" do
      FeatureLoader.register_input(mock('http', :protocols => [:http, :https]))
      @feature_loader.protocols.should include(:http, :https)
    end
    
    it "should raise if it has no input service for the protocol" do
      lambda {
       @feature_loader.load_feature("accidentally://the.whole/thing.feature") 
      }.should raise_error(InputServiceNotFound, /.*'accidentally'.*Services available:.*/)
    end

    it "should parse a feature written in Gherkin" do
      @gherkin_parser.should_receive(:parse).once
      @feature_loader.load_feature("example.feature")
    end
    
    it "should determine the feature format by the file extension" do
      textile_parser = mock('textile parser', :adverbs => ["Given"], :parse => mock('feature', :features= => true), :format => :textile)
      textile_parser.should_receive(:parse).with(anything(), "example.textile", anything(), anything()).once
      @gherkin_parser.should_receive(:parse).with(anything(), "example.feature", anything(), anything()).once
      
      @feature_loader.register_parser(textile_parser)
      @feature_loader.load_features(["example.feature", "example.textile"])
    end
    
    it "should default to the Gherkin format" do
      @gherkin_parser.should_receive(:parse).once
      @feature_loader.load_feature("jbehave.scenario")
    end
        
    it "should say it supports the formats parsed by a registered parser" do
      @feature_loader.register_parser(mock('csv parser', :format => :csv))
      @feature_loader.formats.should include(:csv)
    end
        
    it "should allow a format rule to override extension-based format determination" do
      textile_parser = mock('textile parser', :format => :textile)
      textile_parser.should_receive(:parse).once
      
      @feature_loader.add_format_rule(/\.txt/, :textile)
      @feature_loader.register_parser(textile_parser)
      @feature_loader.load_feature("example.txt")
    end
    
    it "should assume the Gherkin format if there is no extension" do
      @gherkin_parser.should_receive(:parse).once
      @feature_loader.load_feature("example")
    end
    
    it "should allow a format rule set to formats for the same extension via location" do
      textile_parser = mock('textile parser', :format => :textile)
      textile_parser.should_receive(:parse).once      
      @gherkin_parser.should_receive(:parse).once
      
      @feature_loader.register_parser(textile_parser)
      @feature_loader.add_format_rule(/features\/test\/\w+\.feature$/, :textile)
      @feature_loader.load_feature("features/example.feature")
      @feature_loader.load_feature("features/test/example.feature")
    end
    
    it "should raise AmbiguousFormatRules if two or more format rules match" do
      @feature_loader.add_format_rule(/\.foo$/, :gherkin)
      @feature_loader.add_format_rule(/.*/, :gherkin)
      lambda { 
        @feature_loader.load_feature("example.foo")
      }.should raise_error(AmbiguousFormatRules)
    end
    
    it "should pull feature names from a feature list" do
      @file_input.should_receive(:list).with("my_feature_list.txt").and_return(["features/foo.feature", "features/bar.feature"])
      @feature_loader.load_features(["@my_feature_list.txt"])
    end

    it "should have English adverbs by default" do
      @feature_loader.adverbs.should == ["Given", "When", "Then", "And", "But"]
    end
    
    it "should have other adverbs if other languages are used" do
      pending "Adverbs should be moved into the ast feature node and the feature suite"
    end        
  end
end
