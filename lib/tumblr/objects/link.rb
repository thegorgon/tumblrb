module Tumblr
  class Link < Post
    string_attribute :title, :url, :description
  end
end