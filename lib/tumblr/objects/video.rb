module Tumblr
  class Video < Post
    string_attribute :caption
    array_attribute :player, :object => "video/player"

    class Player < Object
      numeric_attribute :width
      string_attribute :embed_code
    end
  end
end