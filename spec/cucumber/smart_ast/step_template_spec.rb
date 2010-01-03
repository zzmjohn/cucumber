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
      end
      
      it "should interpolate variable arguments" do
        @step_template.interpolate(@args).name.should == "5 Cucumbers in my bucket"
      end
    end
  end
end
