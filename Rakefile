require 'rake'
require 'rake/testtask'
require File.join(File.dirname(__FILE__), "lib", "contest")

test_files_pattern = 'test/**/*_test.rb'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = test_files_pattern
  t.verbose = false
end

task :default => [:contest]

task :contest do
  puts "authenticating, caching followers... (this may take a moment)"
  user = User.new

  puts "and the winner is... #{user.random_follower}"
end

