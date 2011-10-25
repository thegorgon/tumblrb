module Tumblr
  class Parsing < Faraday::Response::Middleware
    def parse_body(body)
      case body
      when ''
        nil
      when 'true'
        true
      when 'false'
        false
      else
        JSON.parse(body) rescue nil
      end
    end
    
    def on_complete(env)
      parsed = parse_body(env[:body])
      
      if parsed && parsed.kind_of?(Hash) && parsed["meta"]
        env[:status] = parsed["meta"]["status"]
        env[:message] = parsed["meta"]["msg"]
        env[:body] = Tumblr::Object.objectify(parsed["response"])
      else
        handle_formatting_error(env)
      end
      
    end
  
    def handle_formatting_error(env)
      env[:status] = 500
      env[:message] = "Poorly formatted response"
    end
  end
end