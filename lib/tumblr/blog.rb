module Tumblr 
  class Blog < Object
    extend Query::DelegateMethods
    
    STORAGE_KEY = "gorgon:blog:entries"
    string_attribute :title, :name, :description
    numeric_attribute :posts, :likes
    boolean_attribute :ask, :ask_anon
    date_attribute :updated

    class << self
      attr_accessor :page_size
      
      def page_size
        @page_size ||= 3
      end
      
      def clear!
        Tumblr.config.redis.keys("#{STORAGE_KEY}:*").each { |key| Tumblr.config.redis.del(key) }
        index.clear
      end

      def refresh!(options={})
        clear!

        page = options[:min] || 1
        per_page = options[:per_page] || 100
        max_page = options[:max]

        loop do
          posts = Post.per_page(per_page).page(page)
          if posts.length > 0
            page = posts.next_page
            posts.each do |post|
              puts "I'M ADDING #{post.slug} TO INDEX"
              index << post.slug
              post.commit
            end
            break if page.nil? || (max_page && page > max_page)
          end
        end
        true
      end

      def entries(slugs=nil)
        slugs ||= index
        entries = slugs.collect { |slug| entry(slug) }
        entries.compact!
        entries
      end
      
      def index
        @index ||= Redis::List.new(STORAGE_KEY, Tumblr.config.redis)
      end

      def entry(slug)
        value = Redis::Value.new("#{STORAGE_KEY}:#{slug}", Tumblr.config.redis)
        Tumblr::Object.unserialize(value.value)
      end

      def tags
        Redis::Set.new("#{STORAGE_KEY}:tags", Tumblr.config.redis)
      end
      
      def page(n)
        query.page([1, n.to_i].max)
      end

      def tagged_with(tag)
        query.tagged_with(tag)
      end
      
      private
      
      def query
        @query ||= Query.new(:page, :per_page, :tagged_with) do |params|
          if tag = params[:tagged_with]
            slugs = Redis::Set.new("#{STORAGE_KEY}:tags:#{tag.downcase.underscore}", Tumblr.config.redis)
          else
            slugs = index
          end
          page_size = params[:per_page] || self.page_size
          if page = params[:page]
            WillPaginate::Collection.create(page, page_size, slugs.count) do |pager|
              pager.replace entries(slugs[pager.offset, pager.per_page]).to_a
            end
          else
            entries(slugs).to_a
          end
        end
      end
    end
  end
end