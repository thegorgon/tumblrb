# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tumblr/version', __FILE__)

Gem::Specification.new do |s|
  s.add_dependency('activesupport', '~> 3.0')
  s.add_dependency('json',  '~> 1.6.0')
  s.add_dependency('faraday', '~> 0.7.5')
  s.add_dependency('addressable', '~> 2.2.0')
  s.add_dependency('redis-objects', '~> 0.5.0')
  s.add_dependency('will_paginate', '~> 3.0.0')
  s.authors = ["thegorgon"]
  s.description = %q{A simple blogging platform built on Tumblr and Redis}
  s.email = ['jessereiss@gmail.com']
  s.homepage = 'https://github.com/thegorgon/tumblrb'
  s.name = 'tumblrb'
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = s.name
  s.summary = %q{Ruby wrapper for the Tumblr API}
  s.require_paths << "lib"

  s.files         = [
    "Gemfile",
    "README.mkd",
    "LICENSE.mkd",
    "tumblrb.gemspec",
    "lib/tumblr/api.rb",
    "lib/tumblr/blog.rb",
    "lib/tumblr/config.rb",
    "lib/tumblr/object.rb",
    "lib/tumblr/query.rb",
    "lib/tumblr/quote.rb",
    "lib/tumblr/version.rb",
    "lib/tumblr/middleware/params.rb",
    "lib/tumblr/middleware/parsing.rb",
    "lib/tumblr/objects/answer.rb",
    "lib/tumblr/objects/audio.rb",
    "lib/tumblr/objects/chat.rb",
    "lib/tumblr/objects/link.rb",
    "lib/tumblr/objects/photo.rb",
    "lib/tumblr/objects/post.rb",
    "lib/tumblr/objects/text.rb",
    "lib/tumblr/objects/user.rb",
    "lib/tumblr/objects/video.rb",
    "lib/tumblr.rb",
  ]

  s.version = Tumblr::VERSION.dup
end
