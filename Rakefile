require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'
require 'rubocop/rake_task'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'README*']   # optional
  t.options = ['--markup markdown'] # optional
  t.stats_options = ['--list-undoc']         # optional
end

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: [:spec, :rubocop]
