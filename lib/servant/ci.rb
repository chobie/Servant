module Servant
  class CI
    attr_accessor :home, :user, :password, :cli, :url
    
    def initialize
      @home = ""
      @user = ""
      @password = ""
      @cli = ""
      @url = ""
      @jobs = Servant::JobCollections.new
    end
    
    def jobs(type)
      yield(@jobs)
    end
  end
end