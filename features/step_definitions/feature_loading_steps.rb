Given /^an http server running on localhost:12345 is serving the contents of the features directory$/ do
  FeatureServer.new(12345)
end

After('@feature_server') do
  puts "If you need a feature server killed, I'm your man."
end
