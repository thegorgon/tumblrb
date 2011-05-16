module Tumblr
  class Regular < Item
    attr_accessor :title, :body
    
    def as_json
      super.merge!({
        :title => title,
        :body => body
      })
    end
    
    private
    
    def parse_xml_node(node)
      super(node)
      self.title = node.css('regular-title').first.try(:content)
      self.body = node.css('regular-body').first.try(:content)
      self
    end    
  end
end