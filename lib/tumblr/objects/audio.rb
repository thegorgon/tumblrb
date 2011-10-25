module Tumblr
  class Audio < Post
    string_attribute :caption, :player, :album_art, :artist, :album, :track_name
    numeric_attribute :plays, :track_number, :year
  end
end