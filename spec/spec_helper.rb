require 'rubygems'
gem 'rspec'
require 'spec'
require 'spec/autorun'
require 'spec/cucumber/new_ast/ast_node_spec'

ENV['CUCUMBER_COLORS']=nil
$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'cucumber'
$:.unshift(File.dirname(__FILE__))

Spec::Runner.configure do |config|
  config.before(:each) do
    ::Term::ANSIColor.coloring = true
    Cucumber::Parser::NaturalLanguage.instance_variable_set(:@languages, nil)
  end
end

alias running lambda
