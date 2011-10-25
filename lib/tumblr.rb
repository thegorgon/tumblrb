require 'bundler'
Bundler.require(:default)

require 'active_support/core_ext/string'
require 'active_support/inflections'
require 'active_support/core_ext/array/extract_options'
require "redis/objects"
require "redis/set"
require "redis/value"
require "redis/list"
require 'will_paginate/collection'
require 'tumblr/config'
require 'tumblr/query'
require 'tumblr/api'
require 'tumblr/object'
require 'tumblr/blog'
require 'tumblr/middleware/params'
require 'tumblr/middleware/parsing'

module Tumblr
  def self.configure(&block)
    @config = Config.new
    block.call(@config)
  end
  
  def self.config
    @config
  end
  
  def self.load_config(path)
    @config.load(path)
  end
end