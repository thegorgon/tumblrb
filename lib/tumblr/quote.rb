module Tumblr
  class Quote < Item
    attr_accessor :text, :source
    
    def as_json
      super.merge!({
        :text => text,
        :source => source
      })
    end
    
    private
    
    def parse_xml_node(node)
      super(node)
      self.text = node.css('quote-text').first.try(:content)
      self.source = node.css('quote-source').first.try(:content)
      self
    end    
  end
end