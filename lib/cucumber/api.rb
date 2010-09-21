module Cucumber
  module Api
    def configure
      configuration = Configuration.new
      yield configuration
      Runtime.new(configuration)
    end
  end
end
