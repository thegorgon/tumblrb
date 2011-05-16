module Tumblr
  mattr_accessor :user
  
  def self.blog=(blog)
    @blog = (blog =~ /\./) ? blog : "#{blog}.tumblr.com"
  end
  
  def self.blog
    @blog
  end
end