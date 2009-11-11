Given /^an http server running on localhost:12345 is serving the contents of the features directory$/ do
  FeatureServer.new(12345, working_dir)
end