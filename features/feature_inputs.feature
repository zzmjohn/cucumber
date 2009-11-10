Feature: Feature Inputs

  @feature_server
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
      Something
      """

