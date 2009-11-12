module Cucumber
  module Plugin
    def self.included(plugin)
      plugin.extend(PluginMethods)
    end

    module PluginMethods
      def register_input(input_class)
        FeatureLoader.register_input(input_class.new)
      end
    end
  end
end
