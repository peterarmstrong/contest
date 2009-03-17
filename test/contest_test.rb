require 'test/unit'
require 'rubygems'
require 'redgreen'
require 'rr'

require File.join(File.dirname(__FILE__), "..", "lib", "contest")

class UserTest < Test::Unit::TestCase

  include RR::Adapters::TestUnit

  def test_correct_followers_count
    user = User.new
    assert_equal user.followers_count, user.followers.size
  end

  def test_random_follower_is_a_follower
    user = User.new
    assert user.followers.any?
    assert user.followers.include?(user.random_follower)
  end

  def test_random_follower_is_eligible
    user = User.new
    assert user.followers.any?
    assert !user.ineligibles.include?(user.random_follower)
  end

  def test_no_error_raised_when_ineligible_file_does_not_exist
    stub(Settings).ineligibles { raise Errno::ENOENT }
    assert_nothing_raised { User.new }
  end

end

