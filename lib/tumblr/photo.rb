module Tumblr
  class Photo < Item
    attr_accessor :caption, :sizes
  
    class Size < Struct.new(:url, :max_width)
      def as_json
        {
          :url => url,
          :max_width => max_width
        }
      end
    end

    def max_size
      sizes.last
    end

    def as_json
      super.merge!({
        :caption => caption,
        :sizes => sizes.map { |size| size.as_json }
      })
    end

    private
    
    def parse_xml_node(node)
      super(node)
      self.caption = node.css('photo-caption').first.try(:content)
      self.sizes = node.css("photo-url").collect do |size|
        Size.new(size.content, size['max-width'].to_i)
      end
      self.sizes.sort! { |s1, s2| s1.max_width <=> s2.max_width }
      self
    end    
  end
end