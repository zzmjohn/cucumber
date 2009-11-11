Feature: Feature Inputs

  Scenario: Loading a single feature over HTTP
    Given a standard Cucumber project directory structure
    And a file named "features/remote.feature" with:
      """
      Feature: Hello

        Scenario: Hi
          Given something
          Then something else
      """
    And an http server running on localhost:12345 is serving the contents of the features directory
    When I run cucumber --dry-run -f pretty http://localhost:12345/features/remote.feature
    Then it should pass with
      """
      Feature: Hello

        Scenario: Hi          # http://localhost:12345/features/remote.feature:3
          Given something     # http://localhost:12345/features/remote.feature:4
          Then something else # http://localhost:12345/features/remote.feature:5
      
      1 scenario (1 undefined)
      2 steps (2 undefined)
      
      """

  @wip
  Scenario: Loading many features over HTTP
    Given a standard Cucumber project directory structure
    And a file named "features/remote_1.feature" with:
      """
      Feature: Remote 1

        Scenario: Hi
          Given something
          Then something else
      """
    And a file named "features/remote_2.feature" with:
      """
      Feature: Remote 2

        Scenario: Hi
          Given something
          Then something else
      """
    And a file named "features/feature.list" with:
      """
      remote_1.feature
      remote_2.feature
      """
    And an http server running on localhost:12345 is serving the contents of the features directory
    When I run cucumber --dry-run -f pretty @http://localhost:12345/features/feature.list
    Then it should pass with
      """
      something
      """
