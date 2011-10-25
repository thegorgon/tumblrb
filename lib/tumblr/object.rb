module Tumblr
  class Object
    class << self
      attr_accessor :page_size
      
      def page_size
        @page_size ||= 20
      end
      
      def unserialize(value)
        value = JSON.parse(value)
        systematize(value.first).build(value.last)
      end
      
      def systematize(string)
        string = string.to_s.gsub(/^Tumblr::/, '')
        "Tumblr::#{string.singularize.classify}".constantize rescue nil
      end
      
      def objectify(hash)
        objectified = {}
        hash.keys.each do |key|
          klass = systematize(key)
          if klass
            if hash[key].kind_of?(Array)
              objectified[key] = hash[key].collect { |value| klass.build(value) }
            else
              objectified[key] = klass.build(hash[key])
            end
          else
            objectified[key] = hash[key]
          end
        end
        objectified
      end
      
      def build(attributes)
        object = new
        attributes.each do |attribute, value|
          if object.respond_to?("#{attribute}=")
            object.send("#{attribute}=", value)
          end
        end
        object
      end
      
      def attributes
        @attributes ||= Set.new
      end

      def string_attribute(*args)
        attr_reader *args
        args.each do |arg|
          attributes << arg
          define_method "#{arg}=" do |value|
            set_attribute_value(arg, value.to_s)
          end
        end
      end

      def array_attribute(*args)
        options = args.extract_options!
        attr_reader *args
        klass = systematize(options[:object]) if options[:object]
        args.each do |arg|
          attributes << arg
          define_method "#{arg}=" do |value|
            if klass
              set_attribute_value(arg, value.to_a.collect { |params| klass.build(params) })
            else
              set_attribute_value(arg, value.to_a)
            end
          end
        end
      end

      def boolean_attribute(*args)
        attr_reader *args
        args.each do |arg|
          attributes << arg
          define_method "#{arg}=" do |value|
            set_attribute_value(arg, !!value)
          end
        end
      end

      def numeric_attribute(*args)
        attr_reader *args
        args.each do |arg|
          attributes << arg
          define_method "#{arg}=" do |value|
            value = (value.to_i == value.to_f) ? value.to_i : value.to_f
            set_attribute_value(arg, value)
          end
        end
      end

      def date_attribute(*args)
        attr_reader *args
        args.each do |arg|
          attributes << arg
          define_method "#{arg}=" do |value|
            value = Time.at(value) if value.kind_of?(Fixnum)
            value = Date.parse(value) rescue nil if value.kind_of?(String)
            value ||= value
            set_attribute_value(arg, value)
          end
        end
      end

      def object_attribute(*args)
        attr_reader *args
        options = args.extract_options!
        klass = systematize(options[:object]) if options[:object]
        args.each do |arg|
          attributes << arg
          define_method "#{arg}=" do |value|
            set_attribute_value(arg, klass.build(value))
          end
        end
      end
    end
    
    def serialize
      [self.class.to_s, as_json].to_json
    end
    
    def storage
      @_storage ||= Redis::Value.new("#{Blog::STORAGE_KEY}:#{slug}", Tumblr.config.redis)
    end
    
    def commit
      storage.value = serialize
    end
    
    def dom_class
      self.class.to_s.split("::").last.underscore
    end
    
    def etag
      Digest::SHA1.hexdigest(to_json)
    end
    
    def as_json
      json = {}
      self.class.attributes.each do |key|
        json[key] = send(key)
      end
      json
    end
    
    def to_json(force=false)
      @json = nil if force
      @json ||= JSON.generate(as_json)
    end
    
    private 
    
    def set_attribute_value(key, value)
      self.instance_variable_set("@#{key}", value)
    end
  end
end

require 'tumblr/objects/user'
require 'tumblr/objects/post'
require 'tumblr/objects/audio'
require 'tumblr/objects/chat'
require 'tumblr/objects/link'
require 'tumblr/objects/photo'
require 'tumblr/objects/text'
require 'tumblr/objects/video'
