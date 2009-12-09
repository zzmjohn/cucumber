Feature: Executing features with the Smart AST
  In order to have a sane Ast
  As a Cucumber developer
  I want a Smart AST that makes it easy to execute features

  Background:
    Given a standard Cucumber project directory structure
    And a file named "features/test_gherkin.feature" with:
      """
      Feature: Use the gherkin parser
      
        Background:
          Given some happy little trees
          
        Scenario: Exploding the Furtwangler
          Given the Furtwangler has become vicious
          Then it should explode and spare us the whining
        
        @tagged
        Scenario: Healing the Jackanapes
          Given our pet Jackanapes has scurvy
          Then we should take him to the doctor       
      """
    And a file named "features/step_definitions/gherkin_background_steps.rb" with:
      """
      Given "some happy little trees" do
        @little_trees = "happy"
      end
      """
  
  Scenario: Simple passing/failing
    Given a file named "features/step_definitions/gherkin_steps.rb" with:
      """
      Given "the Furtwangler has become vicious" do
        @furtwangler = "vicious"
      end

      Given "it should explode and spare us the whining" do
        @furtwangler.should_not == "vicious"
      end
      """
    When I run cucumber --gherkin --plugin cucumber/parsers/gherkin.rb --format pretty
    Then the output should contain
      """
      Parsing features/test_gherkin.feature with Gherkin
      Passed: Given some happy little trees
      Passed: Given the Furtwangler has become vicious
      Failed: Then it should explode and spare us the whining

      """

  Scenario: Pending/skipped steps
    Given a file named "features/step_definitions/gherkin_steps.rb" with:
      """
      Given "the Furtwangler has become vicious" do
        pending
      end

      Given "it should explode and spare us the whining" do
      end
      """
    When I run cucumber --gherkin --format pretty
    Then the output should contain
      """
      Parsing features/test_gherkin.feature with Gherkin
      Passed: Given some happy little trees
      Pending: Given the Furtwangler has become vicious
      Skipped: Then it should explode and spare us the whining

      """
  
  Scenario: Before and After hooks
    Given a file named "features/support/gherkin_hooks.rb" with:
      """
      Before do
        puts "Before hook!"
      end
      
      After do
        puts "After hook!"
      end
      """
    When I run cucumber --gherkin --format pretty
    Then the output should contain
      """
      Before hook!
      Passed: Given some happy little trees
      Undefined: Given the Furtwangler has become vicious
      Skipped: Then it should explode and spare us the whining
      After hook!
      """
  
  Scenario: Before hooks do not execute unless a scenario is tagged
    Given a file named "features/support/gherkin_hooks.rb" with:
      """
      Before("@dne") do 
        puts "Tagged before hook!"
      end
      """
    When I run cucumber --gherkin --format pretty
    Then the output should not contain
      """
      Tagged before hook!
      """
  
  Scenario: Before hooks execute before the tagged scenario
    Given a file named "features/support/gherkin_hooks.rb" with:
      """
      Before("@tagged") do
        puts "I have been tagged!"
      end
      """
    When I run cucumber --gherkin --format pretty
    Then the output should contain
      """
      I have been tagged!
      Passed: Given some happy little trees
      Undefined: Given our pet Jackanapes has scurvy
      """