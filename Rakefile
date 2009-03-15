require 'rake'
require File.join(File.dirname(__FILE__), "lib", "contest")

task :default => [:contest]

task :contest do
  puts "authenticating, caching followers... (this may take a moment)"
  user = User.new

  puts "and the winner is...#{user.random_follower}"
end

