require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |spec|
  spec.pattern = 'spec/spec_*.rb'
  spec.rspec_opts = ['--backtrace']
end

task :default  => :test