require 'test/unit'
require 'rubygems'
require 'redgreen'

require File.join(File.dirname(__FILE__), "..", "lib", "contest")

class UserTest < Test::Unit::TestCase

  def test_correct_followers_count
    user = User.new
    assert_equal user.followers_count, user.followers.size
  end

  def test_random_follower
    user = User.new
    assert user.followers.any?
    assert user.followers.include?(user.random_follower)
  end

end

