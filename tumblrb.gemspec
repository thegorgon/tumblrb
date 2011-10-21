# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tumblr/version', __FILE__)

Gem::Specification.new do |s|
  s.add_dependency('activesupport', '~> 3.0')
  s.add_dependency('nokogiri', '~> 1.4.4')
  s.add_dependency('curb', '~> 0.7.15')
  s.add_dependency('addressable')
  s.authors = ["Jesse Reiss"]
  s.description = %q{A Ruby wrapper for the Tumblr XML API}
  s.email = ['jessereiss@gmail.com']
  s.homepage = 'https://github.com/thegorgon/tumblrb'
  s.name = 'tumblrb'
  s.platform = Gem::Platform::RUBY
  s.require_paths << 'lib'
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = s.name
  s.summary = %q{Ruby wrapper for the Tumblr API}
  s.files = [
    "README.mkd",
    "LICENSE.mkd",
    "Gemfile",
    "tumblrb.gemspec",
    "lib/tumblr.rb",
    "lib/tumblr/answer.rb",
    "lib/tumblr/audio.rb",
    "lib/tumblr/conversation.rb",
    "lib/tumblr/item.rb",
    "lib/tumblr/link.rb",
    "lib/tumblr/page.rb",
    "lib/tumblr/photo.rb",
    "lib/tumblr/quote.rb",
    "lib/tumblr/regular.rb",
    "lib/tumblr/user.rb",
    "lib/tumblr/version.rb",
    "lib/tumblr/video.rb"
  ]
  s.version = Tumblr::VERSION.dup
end
