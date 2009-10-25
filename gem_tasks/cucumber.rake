$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'cucumber/rake/task'
require 'cucumber/platform'

Cucumber::Rake::Task.new do |t|
  if(Cucumber::JRUBY)
    t.profile = 'jruby'
  elsif(Cucumber::WINDOWS_MRI)
    t.profile = 'windows_mri'
  end
  t.rcov = ENV['RCOV']
end

Cucumber::Rake::Task.new(:cucumber_wip) do |t|
  t.profile = 'wip'
  t.rcov = ENV['RCOV']
end
