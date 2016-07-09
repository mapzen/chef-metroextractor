#!/usr/bin/env rake

require 'rainbow/ext/string'

desc 'Run integration tests: foodcritic, rubocop, rspec'
task :build do
  puts "\nRunning foodcritic".color(:blue)
  sh 'foodcritic --chef-version 12 --tags ~FC001 --epic-fail correctness .'

  puts 'Running rubocop'.color(:blue)
  sh 'rubocop .'
end

task default: 'build'
