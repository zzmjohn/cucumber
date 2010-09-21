module Cucumber
  module Formatter
    class FormatterBase
      def initialize(hooks)
        @hooks = hooks
      end

      def after_feature_element(feature_element)
        @hooks[:after_scenario].call(feature_element)
      end
    end
    
    def self.new(&block)
      hook_collector = HookCollector.new
      hook_collector.instance_exec(&block)
      FormatterBase.new(hook_collector.hooks)
    end
  end
  
  class HookCollector
    def method_missing(name, &block)
      hooks[name] = block
    end
    
    def hooks
      @hooks ||= {}
    end
  end
end