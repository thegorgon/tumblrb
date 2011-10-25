module Tumblr
  class Config
    attr_accessor :blog, :api_key, :redis
    
    def load(path)
      config = YAML.load_file(path)["tumblr"]
      self.blog = config["blog"]
      self.api_key = config["api_key"]
      self.redis = config["redis"]
    end
    
    def redis=(value)
      value = YAML.load_file(value)["redis"] rescue nil if value.kind_of?(String) && File.exists?(value)
      value = Redis.new(value) if value.kind_of?(Hash)
      unless value.kind_of?(Redis)
        raise ArgumentError, "Tumblr redis accepts a Redis object, path to a YAML file, or hash of Redis options"
      end
      @redis = value
    end
    
    def blog=(value)
      @blog = (blog =~ /\./) ? blog : "#{value}.tumblr.com"
    end
  end
end