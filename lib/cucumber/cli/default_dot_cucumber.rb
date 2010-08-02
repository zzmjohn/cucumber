Cucumber.configure do |c|
  c.require_files_under('features/support', /env\.rb$/) # Load all support files, loading files mathing  /env\.rb$/ first.
  c.require_files_under('features/step_definitions')    # Load all step definitions
end