Feature: Before Hook

  Scenario: Examine names of elements
    Given a file named "features/foo.feature" with:
      """
      Feature: Feature name

        Scenario: Scenario name
          Given a step

        Scenario Outline: Scenario Outline name
          Given a <placeholder>

          Examples: Examples Table name
            | placeholder |
            | row         |
      """
    And a file named "features/support/hook.rb" with:
      """
      names = []
      Before do |unit|
        names << unit.feature_name
        # You could either pass in a visitor, or use this block
        # to build one.
        unit.visit_source do |visitor_builder|
          visitor_builder.scenario do |scenario|
            names << scenario.name
          end
          visitor_builder.examples_table_row do |row|
            names << row.scenario_outline_name
            names << row.examples_table_name
            names << row.number
          end
        end
      end
      at_exit { puts names.join("\n") }
      """
    When I run `cucumber`
    Then the output should contain exactly:
      """
      Feature name
      Scenario name
      Scenario Outline name
      Examples Table name
      1
      """

