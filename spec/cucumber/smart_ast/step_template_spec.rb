require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cucumber/smart_ast/step_template'
require 'cucumber/smart_ast/py_string'
require 'cucumber/smart_ast/table'

module Cucumber
  module SmartAst
    describe StepTemplate do
      before do
        @step_template = StepTemplate.new("Given", "<num> Cucumbers in my <object>", 1, nil)
        @args = { "num" => "5", "object" => "bucket", "foo" => "bar" }
        @headers = %w(num object)
      end
      
      it "should interpolate variable arguments" do
        @step_template.interpolate(@args, @headers).should == Step.new("Given", "5 Cucumbers in my bucket", 1, nil)
      end
      
      it "should store the inerpolated arguments" do
        @step_template.interpolate(@args, @headers).interpolated_args.should == ["5", "bucket"]
      end
      
      it "should return a new object when interpolating to preserve its status as a Value" do
        @step_template.interpolate(@args, @headers).should_not === @step_template
      end
      
    end
  end
end
