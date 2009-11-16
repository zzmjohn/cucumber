module Cucumber
  module Plugin
    def register_input(input_class)
      FeatureLoader.register_input(input_class)
    end
  end
end
