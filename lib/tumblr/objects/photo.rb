module Tumblr
  class Photo < Post
    array_attribute :photos
    array_attribute :sizes
    string_attribute :caption
    numeric_attribute :width, :height

    class Size < Object
      string_attribute :url
      numeric_attribute :width, :height
    end

    def photos=(value)
      photos = value.collect do |value|
        object = Tumblr::Photo.new
        object.caption = value["caption"]
        object.sizes = value["alt_sizes"].collect { |size| Size.build(size) }
      end
      set_attribute_value(:photos, photos)
    end  
  end
end