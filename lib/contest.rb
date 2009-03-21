require 'rubygems'
require 'rest_client'
require 'nokogiri'
require 'open-uri'

module Resource
  def self.get(path, node, user)
    resource  = RestClient::Resource.new(path, 
                                         user.name, 
                                         user.password)

    Nokogiri::XML(resource.get).xpath("//#{node}").collect do |each| 
      each.inner_html.to_s.strip
    end
  end
end

module Settings
  def self.credentials
    path = File.join(File.join(ENV['HOME'], ".twitter"), "credentials.yml")
    YAML::load_file(path)
  end

  def self.ineligibles
    path = File.join(File.join(ENV['HOME'], ".twitter"), "ineligible.yml")
    YAML::load_file(path)['ineligible']
  end
end

class User
  attr_accessor :name, :password, :followers, :followers_count, :ineligibles

  def initialize
    get_credentials
    get_ineligibles
    get_followers_count
    get_followers
  end

  def random_follower
    winner = followers[rand(followers_count)]
    return winner unless ineligibles.include?(winner)
    random_follower
  end

  protected

  def get_credentials
    credentials = Settings.credentials
    @name       = credentials['name']
    @password   = credentials['password']
  end

  def get_ineligibles
    begin
      @ineligibles = Settings.ineligibles
    rescue
      @ineligibles = []
    end
  end

  def get_followers_count
    path     = "http://twitter.com/users/show/#{name}.xml"
    property = "followers_count"
    @followers_count = Resource.get(path, property, self).first.to_i
  end

  def get_followers
    @followers = []
    page_count.times do |page|
      @followers += followers_for_page(page+1)
    end
    @followers.compact!
  end

  def page_count
    followers_per_page = 100
    page_count = (followers_count.to_f / 
                  followers_per_page.to_f).ceil
  end

  def followers_for_page(page)
    path     = "http://twitter.com/statuses/followers.xml?page=#{page}"
    property = "screen_name"
    Resource.get(path, property, self)
  end
end

