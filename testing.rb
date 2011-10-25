require 'bundler'
Bundler.require
require 'tumblr'

Tumblr.configure do |config|
  config.blog = "thegorgonlab"
  config.api_key = "1pLfP3eTlFjZi3trs2Medo78EwAaOLxMEAHUsRpfEoOS3nhbd8"
  config.redis = {:host => "localhost", :port => 2811}
end