# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tumblr/version', __FILE__)

Gem::Specification.new do |s|
  s.add_dependency('activesupport', '~> 3.0')
  s.add_dependency('json',  '~> 1.6.0')
  s.add_dependency('nokogiri', '~> 1.4.4')
  s.add_dependency('curb', '~> 0.7.15')
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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.version = Tumblr::VERSION.dup
end
