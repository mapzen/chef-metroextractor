#!/usr/bin/env rake

require 'rainbow/ext/string'

desc 'Run integration tests: foodcritic, rubocop, rspec'
task :build do
  sandbox = File.join(File.dirname(__FILE__), %w(tmp cookbook))
  prepare_sandbox(sandbox)

  puts "\nRunning foodcritic".color(:blue)
  sh "foodcritic --chef-version 11.10 --tags ~FC001 --epic-fail correctness #{File.dirname(sandbox)}/cookbook"

  puts 'Running rubocop'.color(:blue)
  sh "rubocop #{File.dirname(sandbox)}/cookbook"
end

task default: 'build'

private

def prepare_sandbox(sandbox)
  files = %w(Rakefile *.md *.rb attributes definitions files libraries providers recipes resources spec templates)

  puts 'Preparing sandbox'.color(:blue)
  rm_rf sandbox
  mkdir_p sandbox
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox
end
