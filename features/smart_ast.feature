Feature: Executing features with the Smart AST
  In order to have a sane Ast
  As a Cucumber developer
  I want a Smart AST that makes it easy to execute features

  Background:
    Given a standard Cucumber project directory structure
    And a file named "features/test_gherkin.feature" with:
      """
      Feature: Use the gherkin parser

        Scenario: Exploding the Furtwangler
          Given the Furtwangler has become vicious
          Then it should explode and spare us the whining
      """
  
  Scenario: Gherkin plugin simple passing/failing
    Given a file named "features/step_definitions/steps.rb" with:
      """
      Given "the Furtwangler has become vicious" do
        @furtwangler = "vicious"
      end

      Given "it should explode and spare us the whining" do
        @furtwangler.should_not == "vicious"
      end
      """
    When I run cucumber --gherkin --plugin cucumber/parsers/gherkin.rb --format pretty
    Then the output should be
      """
      Parsing features/test_gherkin.feature with Gherkin
      Passed: Given the Furtwangler has become vicious
      Failed: Then it should explode and spare us the whining

      """

  @wip
  Scenario: Gherkin plugin pending/skipped steps
    Given a file named "features/step_definitions/steps.rb" with:
      """
      Given "the Furtwangler has become vicious" do
        pending
      end

      Given "it should explode and spare us the whining" do
      end
      """
    When I run cucumber --gherkin --format pretty
    Then the output should be
      """
      Parsing features/test_gherkin.feature with Gherkin
      Pending: Given the Furtwangler has become vicious
      Skipped: Then it should explode and spare us the whining

      """

