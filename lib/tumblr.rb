require 'nokogiri'
require 'curl'
require 'tumblr/user'
require 'tumblr/page'
require 'tumblr/item'
require 'tumblr/answer'
require 'tumblr/audio'
require 'tumblr/conversation'
require 'tumblr/item'
require 'tumblr/link'
require 'tumblr/photo'
require 'tumblr/quote'
require 'tumblr/regular'
require 'tumblr/video'

module Tumblr
  mattr_accessor :user
  
  def self.blog=(blog)
    @blog = (blog =~ /\./) ? blog : "#{blog}.tumblr.com"
  end
  
  def self.blog
    @blog
  end
end