require 'sinatra/base'

class FeatureServer
  class App < Sinatra::Base
    get '/features/:feature' do
      send_file options.root + "/features/#{params[:feature]}"
    end
  end

  def initialize(port, features_dir)
    Thread.new do
      App.run! :host => 'localhost', :port => port, :root => features_dir
    end
  end
end
