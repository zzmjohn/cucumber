Feature: Retrieving features from different sources
  In order to work with customers who aren't comfortable with text editors
  As a developer using Cucumber
  I want to be able to load features from different sources

  Background:
    Given a standard Cucumber project directory structure
    And a file named "features/remote_1.feature" with:
      """
      Feature: Remote Feature One

        Scenario: Exploding the Furtwangler
          Given the Furtwangler has become vicious
          Then it should explode and spare us the whining
      """
    And a file named "features/remote_2.feature" with:
      """
      Feature: Remote Feature Two

        Scenario: Healing the Jackanapes
          Given our pet Jackanapes has scurvy
          Then we should take him to the doctor
      """
    And a file named "features/feature.list" with:
      """
      http://localhost:12345/features/remote_1.feature
      http://localhost:12345/features/remote_2.feature
      """

  Scenario: Single feature via HTTP
    Given an http server on localhost:12345 is serving the contents of the features directory
    When I run cucumber --dry-run -f pretty http://localhost:12345/features/remote_1.feature
    Then it should pass with
      """
      Feature: Remote Feature One

        Scenario: Exploding the Furtwangler               # http://localhost:12345/features/remote_1.feature:3
          Given the Furtwangler has become vicious        # http://localhost:12345/features/remote_1.feature:4
          Then it should explode and spare us the whining # http://localhost:12345/features/remote_1.feature:5

      1 scenario (1 undefined)
      2 steps (2 undefined)
      
      """

  Scenario: Many features over HTTP
    Given an http server on localhost:12345 is serving the contents of the features directory
    When I run cucumber --dry-run -f progress @http://localhost:12345/features/feature.list
    Then it should pass with
      """
      UUUU

      2 scenarios (2 undefined)
      4 steps (4 undefined)

      """
