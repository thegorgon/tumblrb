module Tumblr
  class Answer < Post
    string_attribute :asking_name, :asking_url, :question, :answer
  end
end