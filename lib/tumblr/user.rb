module Tumblr
  class User
    attr_accessor :email, :password, :tumblr
  
    # creates a User object and authenticates the user through the Tumblr API to get user data.  
    def initialize(email, password)
      self.email = email
      self.password = password
    end
  end
end