Feature: Pluggable parsers
  In order to parse features in many formats
  As a developer using Cucumber
  I want to write parser plugins

  @wip
  Scenario: Gherkin plugin
    Given a standard Cucumber project directory structure
    And a file named "features/gherkin.feature" with:
      """
      Feature: Use the gherkin parser

        Scenario: Exploding the Furtwangler
          Given the Furtwangler has become vicious
          Then it should explode and spare us the whining
      """  
    When I run cucumber --dry-run -f progress --plugin cucumber/parsers/gherkin.rb features/gherkin.feature
    Then it should pass with
      """
      Using Gherkin parser

      """
