require 'sinatra/base'

class FeatureServer
  class App < Sinatra::Base
    get '/features/remote.feature' do
      f = %Q{
        Feature: foo
      }
    end
  end

  def initialize(port)
    Thread.new do
      App.run! :host => 'localhost', :port => port
    end
  end
end
