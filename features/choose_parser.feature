Feature: Choose Parser
  In order to let people play with gherkin before we ditch treetop
  Users should be able to choose the gherkin parser with --gherkin

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
    When I run cucumber -q --format pretty --gherkin features/f.feature
    Then the output should contain
      """
      Parsing features/f.feature with Gherkin
      """