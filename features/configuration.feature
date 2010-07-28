Feature: Options
  In order to make it easier for Cucumber plugins to run seamlessly
  As a Cuke developer
  I want to configure Cucumber from within a cucumber execution

  Background:
    Given a standard Cucumber project directory structure

  Scenario: Tags
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

  Scenario: HTML formatter
    Given a standard Cucumber project directory structure
    And a file named "features/support/env.rb" with:
      """
      Cucumber.configure do |config|
        config.formats << ['html', config.out_stream]
      end
      """
    When I run cucumber features
    Then STDERR should be empty
    And the output should contain
      """
      html
      """

  Scenario: feature directories read from configuration
    Given a standard Cucumber project directory structure
    And a file named "features/support/env.rb" with:
      """
      Cucumber.configure do |config|
        config.out_stream << "Read feature directories: #{config.feature_dirs.join(', ')}"
      end
      """
    When I run cucumber features
    Then STDERR should be empty
    And the output should contain
      """
      Read feature directories: features
      """

  Scenario: configuring outside of support
    Given a standard Cucumber project directory structure
    And a file named "features/step_definitions/cheat_steps.rb" with:
      """
      Cucumber.configure do |config|
        config.formats << ['html', config.out_stream]
      end
      """
    When I run cucumber features
    Then it should pass with
    """
    html
    """

  Scenario: configuring during Cucumber execution
    Given a standard Cucumber project directory structure
    And a file named "features/philosophers.feature" with:
    """
    Feature: Drunken Philosophers
      Scenario: I drink therefore I am
        Given Immanuel Kant was a real pissant
    """
    And a file named "features/step_definitions/steps.rb" with:
    """
      Given /^Immanuel Kant was a real pissant$/ do
        Cucumber.configure do |config|
           config.tags = ['@wip']
         end
      end
    """
    When I run cucumber features
    Then it should fail with
    """
    You cannot modify configuration once Cucumber has started executing features.
    """
  
  @wip
  Scenario: Profiles
    Given a standard Cucumber project directory structure
    And a file named "features/support/env.rb" with:
      """
      Cucumber.configure('html_it') do |config|
        config.formats << ['html', config.out_stream]
      end
      
      Cucumber.configure('progress') do |config|
        config.formats << ['pretty', config.out_stream]
      end
      
      """
    When I run cucumber features --profile html_it
    Then it should pass with
    """
    html
    """