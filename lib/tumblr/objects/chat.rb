module Tumblr
  class Chat < Post
    string_attribute :title, :body
    array_attribute :dialogue, :object => "chat/dialogue"

    class Dialogue < Object
      string_attribute :name, :label, :phrase
    end
  end
end