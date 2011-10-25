module Tumblr
  class Query
    module DelegateMethods
      [:first, :last, :all, :length].each do |method|
        define_method method do
          query.send(method)
        end
      end
    end
    
    def initialize(*parameters, &block)
      @params = {}
      @param_keys = parameters.to_a
      @fetch_block = block
    end
    
    [:first, :last, :count, :to_xml, :to_yaml, :length, :collect, :map, :each, :all?, :include?].each do |method|
      define_method method do |*args, &block|
        to_a.send(method, *args, &block)
      end
    end
    
    def all
      to_a
    end
    
    def to_a
      if @array && @array.length > 0
        @array
      else
        @array = @fetch_block.call(@params)
      end
    end
    
    def method_missing(method, *args, &block)
      if @param_keys.include?(method.to_sym)
        value = args.length == 1 ? args.first : args
        @array = nil if value != @params[method.to_sym]
        @params[method.to_sym] = value
        self
      elsif to_a.respond_to?(method)
        to_a.send(method, *args, &block)
      else
        super(method, *args, &block)
      end
    end
  end
end