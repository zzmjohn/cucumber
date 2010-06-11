Feature: RubyMine

  Scenario: A single Around hook
    Given a standard Cucumber project directory structure
    And a file named "features/hello.feature" with:
      """
      Feature: Hello
        Scenario Outline: Outline
          Given I have <n> cukes in my belly
        
          Examples:
            | n |
            | 7 |
            | 9 |
      """
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given /^I have (\d+) cukes in my belly$/ do |n|
      end
      """
    And a file named "features/support/jetbrains/custom.rb" with:
      """
      module Jetbrains
        class Custom
          def initialize(step_mother, io, options)
            @io = io
          end

          def before_feature(feature)
            @io.puts feature.short_name.upcase
          end
        end
      end
      """
    And a file named "Rakefile" with:
      """
      require 'cucumber/rake/task'

      Cucumber::Rake::Task.new do |t|
        t.cucumber_opts = %w{--format progress}
      end
      """
    When I run rake cucumber CUCUMBER_OPTS="--expand" CUCUMBER_FORMAT="Jetbrains::Custom"
    Then it should pass with
      """
      Hello
      """
