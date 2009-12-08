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
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given "the Furtwangler has become vicious" do
        @furtwangler = "vicious"
      end

      Given "it should explode and spare us the whining" do
        @furtwangler.should_not == "vicious"
      end
      """
    When I run cucumber --gherkin --plugin cucumber/parsers/gherkin.rb --format pretty --dry-run
    Then the output should be
      """
      Parsing features/test_gherkin.feature with Gherkin
      Passed: Given the Furtwangler has become vicious
      Failed: Then it should explode and spare us the whining

      """
