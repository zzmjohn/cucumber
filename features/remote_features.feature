Feature: Loading features from remote sources
  In order to work with customers who would like to create and store their features
    in their preferred environments
  As a developer using Cucumber
  I want to be able to load features from wherever the customer keeps them

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
      http://localhost:22225/features/remote_1.feature
      http://localhost:22225/features/remote_2.feature
      """

  @feature_server
  Scenario: Single feature via HTTP
    Given an http server on localhost:22225 is serving the contents of the features directory
    When I run cucumber --dry-run -f pretty http://localhost:22225/features/remote_1.feature
    Then it should pass with
      """
      Feature: Remote Feature One

        Scenario: Exploding the Furtwangler               # http://localhost:22225/features/remote_1.feature:3
          Given the Furtwangler has become vicious        # http://localhost:22225/features/remote_1.feature:4
          Then it should explode and spare us the whining # http://localhost:22225/features/remote_1.feature:5

      1 scenario (1 undefined)
      2 steps (2 undefined)
      
      """

  @feature_server
  Scenario: Many features via HTTP
    Given an http server on localhost:22225 is serving the contents of the features directory
    When I run cucumber --dry-run -f progress @http://localhost:22225/features/feature.list
    Then it should pass with
      """
      UUUU

      2 scenarios (2 undefined)
      4 steps (4 undefined)

      """

  @feature_server @wip
  Scenario: Loading features via an input plugin
    Given a fakeproto server on localhost:22225 is serving the contents of the features directory
    And a file named "features/support/fake_proto_input.rb" with:
      """
      # The FakeProto input is really an HTTP input so we can use the Sinatra feature-server for testing
      require 'open-uri'

      class FakeProto < Cucumber::Inputs::Plugin
        register(self)

        def protocols
          :fakeproto
        end

        def read(uri)
          uri.gsub!(/^fakeproto/, 'http')
          open(uri).read
        end
      end
      """
    When I run cucumber --dry-run -f progress --plugin FakeProtoInput fakeproto://localhost:22225/features/remote_1.feature
    Then it should pass with
      """
      UU

      1 Scenario (1 undefined)
      2 Steps (2 undefined)

      """
