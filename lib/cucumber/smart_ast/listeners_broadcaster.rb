module Cucumber
  module SmartAst
    module ListenersBroadcaster
      
      [
        :before_feature, 
        :after_feature,
        :before_unit,
        :after_unit,
        :before_step,
        :after_step
      ].each do |method|
        define_method(method) do |*args|
          each { |l| l.send(method, *args) if l.respond_to?(method) }
        end
      end
    end
  end
end