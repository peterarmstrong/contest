require 'rubygems'
require 'rest_client'
require 'nokogiri'
require 'open-uri'

PER_PAGE = 100

class User
  attr_accessor :name, :password, :followers

  def initialize(opts = {})
    @name      = opts[:name]
    @password  = opts[:password]
    find_followers
  end

  def find_followers
    @followers ||= []
    page_count.times do |page|
      @followers += followers_for_page(page+1)
    end
    @followers.uniq!
    @followers.compact!
    @followers
  end

  def random_follower
    followers[rand(followers.size)]
  end

  def page_count
    page_count = (followers_count.to_f / PER_PAGE.to_f).ceil
  end

  def followers_for_page(page)
    followers_path = "http://twitter.com/statuses/followers.xml?page=#{page}"
    resource       = RestClient::Resource.new(followers_path, name, password)

    Nokogiri::XML(resource.get).xpath("//screen_name").collect do |each| 
      each.inner_html.to_s.strip
    end
  end

  def followers_count
    user_path = "http://twitter.com/users/show/#{name}.xml"
    resource  = RestClient::Resource.new(user_path, name, password)

    Nokogiri::XML(resource.get).xpath("//followers_count").collect do |each| 
      each.inner_html.to_s.strip
    end.first.to_i
  end

end

puts "looking for credentials file..."

credentials_path = File.join(ENV['HOME'], ".twitter.yml")
credentials      = YAML::load_file(credentials_path)

puts "authenticating, caching followers... (this may take a moment)"

user = User.new(:name     => credentials['name'], 
                :password => credentials['password'])

puts "and the winner of the contest is..."

puts user.random_follower

