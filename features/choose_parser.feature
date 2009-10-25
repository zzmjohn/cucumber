@wip
Feature: Choose Parser
  In order to let people play with gherkin before we ditch treetop
  Users should be able to set the parser with --parser.

  Scenario: Use Gherkin
    Given a standard Cucumber project directory structure
    And a file named "features/f.feature" with:
      """
      Feature: F
        Scenario: S
          Given G
      """
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given /G/ do
      end
      """
    When I run cucumber -q --format pretty --parser gherkin features/f.feature
    Then STDERR should be empty
    Then it should pass with
      """
      Feature: F

        Scenario: S
          Given G

      1 scenario (1 passed)
      1 step (1 passed)

      """
