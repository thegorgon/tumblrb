module Tumblr
  class User < Object
    numeric_attribute :following
    string_attribute :default_post_format, :name
    array_attribute :blogs, :object => :blog
  end
end