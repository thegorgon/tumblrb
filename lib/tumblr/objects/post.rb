module Tumblr
  class Post < Object
    extend Query::DelegateMethods
    numeric_attribute :id
    date_attribute :date, :timestamp
    string_attribute :slug, :blog_name, :post_url, :source_url, :source_title, :format
    array_attribute :tags
    boolean_attribute :mobile, :bookmarklet
    
    def self.build(attributes)
      klass = attributes["type"] ? Object.systematize(attributes["type"]) : self
      if klass && klass != self
        klass.build(attributes)
      else
        super
      end
    end
    
    def self.page(n)
      query.page([1, n.to_i].max)
    end
    
    def self.per_page(n)
      query.per_page(n)
    end
    
    def self.type(type)
      query.type(type)
    end
    
    def self.tagged_with(tag)
      query.tag(tag)
    end
    
    def self.find(id)
      query.id(id).first
    end
    
    def commit
      super
      tags.each do |tag|
        Redis::Set.new("#{Blog::STORAGE_KEY}:tags", Tumblr.config.redis) << tag.downcase
        Redis::List.new("#{Blog::STORAGE_KEY}:tags:#{tag.downcase.underscore}", Tumblr.config.redis) << slug
      end
    end
    
    def html?
      format == "html"
    end
    
    def markdown?
      format == "markdown"
    end
    
    def slug
      @slug ||= title.parameterize
    end
    
    def to_param
      slug
    end
    
    private
    
    def self.query
      @query ||= Query.new(:page, :per_page, :type, :id, :tag) do |params|
        page_size = params[:per_page] || self.page_size
        page = [1, params[:page].to_i].max
        req_params = {
          :limit => page_size,
          :offset => page_size * (page - 1)
        }
        [:type, :id, :tag].each do |key|
          req_params[key] = params[key] if params[key]
        end
        
        if params.key?(:per_page) || params.key?(:page)
          results = Api.get('posts', req_params)
          WillPaginate::Collection.create(page, page_size, results.body["total_posts"]) do |pager|
            pager.replace results.body["posts"]
          end
        else
          results = Api.get('posts', :limit => req_params)
          results.body["posts"]
        end
      end
    end
  end
end