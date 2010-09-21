Feature: Run features from code
  In order to write tools on top of Cucumber
  As a tool developer
  I want a stable, easy-to-use API
  
  Background:
    Given a standard Cucumber project directory structure
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given(/pass/) {}
      """
    And a file named "features/foo.feature" with:
      """
      Feature:
        Scenario: Foo
          Given I pass
      """
  
  Scenario: Run a single feature
    And a file named "test.rb" with:
      """
      require 'rubygems'
      require 'gherkin'
      require 'cucumber'
      
      runtime = Cucumber.configure do |config|
        config.listeners << Cucumber::Listener.new do
          before_all do |runtime|
            puts "Just about to run the lot"
          end

          after_each do |scenario_result|
            puts "Just ran #{scenario_result.name}"
          end

          before_each do |scenario|
            puts "About to run #{scenario.name}"
          end
        end
      end
      
      runtime.run
      """
    When I run ruby test.rb
    Then it should pass
    And the output should contain:
      """
      Foo
      """
    And the output should contain:
      """
      run the lot
      """
