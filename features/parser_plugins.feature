Feature: Pluggable parsers
  In order to parse features in many formats
  As a developer using Cucumber
  I want to write parser plugins

  @wip
  Scenario: Gherkin plugin
    Given a standard Cucumber project directory structure
    And a file named "features/test_gherkin.feature" with:
      """
      Feature: Use the gherkin parser

        Scenario: Exploding the Furtwangler
          Given the Furtwangler has become vicious
          Then it should explode and spare us the whining
      """  
    When I run cucumber --dry-run --plugin cucumber/parsers/gherkin.rb features/test_gherkin.feature
    Then the output should contain
      """
      Using Gherkin parser
      """
    And it should pass with
      """
      Using Gherkin parser
      Feature: Use the gherkin parser

        Scenario: Exploding the Furtwangler
          Given the Furtwangler has become vicious
          Then it should explode and spare us the whining

      1 scenario (1 undefined)
      2 steps (2 undefined)

      """
