require 'spec_helper'

describe Cucumber::Configuration do
  context "by default" do
    it "includes features/support and features/step_definitions in auto_load_paths" do
      subject.auto_load_paths.should include('features/step_definitions')
      subject.auto_load_paths.should include('features/support')
    end
  end
end
