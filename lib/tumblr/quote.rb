module Tumblr
  class Quote < Post
    string_attribute :text, :source
  end
end