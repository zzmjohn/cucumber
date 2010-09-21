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
        config.formatters << Cucumber::Formatter.new do
          after_scenario do |scenario|
            puts scenario.name
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
