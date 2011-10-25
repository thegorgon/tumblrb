module Tumblr
  class Params < Faraday::Middleware
    def call(env)
      params = env[:url].query_values || {}
      env[:url].query_values ||= {}
      env[:url].query_values = { 'api_key' => Tumblr::Config.api_key }.merge!(params)
      @app.call env
    end
  end
end