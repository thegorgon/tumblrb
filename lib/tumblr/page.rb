module Tumblr
  class Page
    include Enumerable
    attr_accessor :items, :start, :total, :page_size
    
    def initialize(items, start, total, page_size)
      self.items = items
      self.start = start.to_i
      self.total = total.to_i
      self.page_size = page_size.to_i
    end
        
    def page
      (start / page_size).floor + 1      
    end
    
    def success?
      items.count > 0
    end
    
    def next_page
      (total - start) > page_size ? page + 1 : nil
    end
    
    def previous_page
      page > 1 ? page - 1 : nil
    end
    
    [:size, :count, :length].each do |m|
      define_method m do
        @items.send(m)
      end
    end    
    
    def each(&block)
      items.each(&block)
    end
  end
end