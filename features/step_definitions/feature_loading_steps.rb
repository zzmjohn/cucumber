Given /^an http server on localhost:(\d+) is serving the contents of the features directory$/ do |port|
  FeatureServer.new(port, working_dir)
end
