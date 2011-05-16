module Tumblr
  class Item
    PAGE_SIZE = 20
    attr_accessor :id, :slug, :type, :date, :format, :xml
    attr_accessor :tags
    
    def self.paginate(params={})
      params[:num] = params[:per_page].to_i > 0 ? params[:per_page].to_i : PAGE_SIZE
      params[:start] = ([params[:page].to_i, 1].max - 1) * params[:num]
      params.delete(:limit)
      params.delete(:page)
      if Tumblr.user
        params[:email] = Tumblr.user.email
        params[:password] = Tumblr.user.password
      end
      page_xml = xml(params)
      items = parse(page_xml)
      page_meta = page_xml.at("posts")
      if page_meta
        Tumblr::Page.new(items, page_meta["start"], page_meta["total"], params[:num])
      else
        Tumblr::Page.new(items, 0, items.length, params[:num])
      end
    end
    
    def self.find(id)
      paginate(:page => 1, :per_page => 1).first
    end
    
    def self.all(params={})
      parse(xml(params))
    end
    
    def self.xml(params={})
      Nokogiri::XML(raw(params))
    end
    
    def self.raw(params={})
      Rails.logger.info "tumblr : fetching url #{url(params)}"
      curl = Curl::Easy.perform(url(params))
      curl.body_str
    end

    def self.find(id)
      parse(xml(:id => id.to_i)).first
    end
    
    def to_param
      "#{id}-#{slug}"
    end
    
    def date_string
      date.strftime("%B %d, %Y")
    end
    
    def dom_class
      self.class.to_s.split("::").last.underscore
    end

    def as_json
      {
        :id => id,
        :slug => slug,
        :date => date,
        :type => type,
        :format => format,
        :tags => tags
      }
    end

    private

    def self.url(params)
      url = "http://#{Tumblr.blog}/api/read"
      url += "?#{params.to_query}" if params.keys.length > 0
      url
    end

    def self.parse(xml)
      xml.css("posts post").collect do |post|
        object_class = "Tumblr::#{post['type'].classify}".constantize rescue nil
        if object_class
          object = object_class.new
          object.send(:parse_xml_node, post)
          object
        end
      end
    end
    
    def parse_xml_node(node)
      self.xml = node.to_s
      self.id = node['id']
      self.type = node['type']
      self.slug = node['slug']
      self.date = Time.at(node['unix-timestamp'].to_i)
      self.format = node['format']
      self.tags = node.css("tag").collect do |tag|
        tag.content
      end
      self
    end    
  end
end