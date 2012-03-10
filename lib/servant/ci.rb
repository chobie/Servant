module Servant
  class CI
    attr_accessor :home, :user, :cli, :url, :cli_options
    
    def initialize
      @home = ""
      @user = ""
      @cli = ""
      @url = ""
      @cli_options = []
      @jobs = Servant::JobCollections.new
    end
    
    def jobs(type)
      yield(@jobs)
    end
  end
end