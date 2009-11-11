require 'sinatra/base'

class FeatureServer < Sinatra::Base
  get '/features/:feature' do
    send_file options.root + "/features/#{params[:feature]}"
  end
end
