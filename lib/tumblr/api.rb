module Tumblr
  class Api  
    class Exception < IOError; end

    class << self
      def connection
        unless @connection
          @connection = ::Faraday.new(:url => host) do |builder|
            builder.use ::Faraday::Request::UrlEncoded
            builder.use ::Faraday::Response::Logger
            builder.use Tumblr::Params
            builder.use Tumblr::Parsing
            builder.adapter ::Faraday.default_adapter
          end
        end
        @connection
      end
    
      def get(method, params={})
        response = nil
        5.times do |attempt|
          response = connection.get path(method, params)
          break if response.success?
        end
        if response && response.success?
          response
        else
          error = response ? "#{response["status"]}: #{response["message"]}" : "Something went wrong"
          raise Tumblr::Api::Exception.new(error)
        end
      end
    
      def url(method='', params={})
        "#{host}#{path(method, params)}"
      end
    
      def host
        "http://api.tumblr.com"
      end
    
      def path(method="", params={})
        uri = Addressable::URI.new
        params.keys.each { |key| params[key] = params[key].to_s }
        uri.query_values = params
        "/v2/blog/#{Tumblr.config.blog}/#{method}?#{uri.query}"
      end
    end
  end
end