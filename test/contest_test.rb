require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'quietbacktrace'
require 'redgreen'

require File.join(File.dirname(__FILE__), "..", "lib", "contest")

class UserTest < Test::Unit::TestCase
  context "a User with valid credentials" do
    setup do
      credentials_path = File.join(ENV['HOME'], ".twitter.yml")
      credentials      = YAML::load_file(credentials_path)
      @user = User.new(:name     => credentials['name'], 
                       :password => credentials['password'])
    end

    should "have equal number of followers as their official follower count" do
      assert_equal @user.followers_count, @user.followers.size
    end

    should "pick a random follower" do
      assert @user.followers.any?
      assert @user.followers.include?(@user.random_follower)
    end
  end
end

