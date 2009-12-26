module Cucumber
  module SmartAst
    module ListenersBroadcaster
      
      [:before_scenario, :after_scenario, :before_feature, :after_feature].each do |method|
        define_method(method) do |*args|
          each { |l| l.send(method, *args) if l.respond_to?(method) }
        end
      end
    end
  end
end