Feature: Options
  In order to make it easier for Cucumber plugins to run seamlessly
  As a Cuke developer
  I want to configure Cucumber from within a cucumber execution

  Background:
    Given a standard Cucumber project directory structure

  Scenario: Valid options
    Given a file named "features/philosophers.feature" with:
    """
    Feature: Drunken Philosophers
      Scenario: I drink therefore I am
        Given Immanuel Kant was a real pissant

      @wip
      Scenario: Failing drunk
        Given fail
    """
    And a file named "features/step_definitions/steps.rb" with:
    """
      Given /^Immanuel Kant was a real pissant$/ do
      end

      Given /^fail$/ do
        fail
      end
    """
    And a file named "features/support/env.rb" with:
    """
      Cucumber.configure do |c|
        c.tags = ['~@wip']
      end
    """
    When I run cucumber features --format progress
    Then it should pass with
    """
    .

    1 scenario (1 passed)
    1 step (1 passed)

    """

  Scenario: Invalid options
    Given a file named "features/support/env.rb" with:
    """
      Cucumber.configure do |c|
        c.heidegger = 'boozy'
      end
    """
    When I run cucumber features
    Then STDERR should match
    """
    invalid option: --heidegger
    """
