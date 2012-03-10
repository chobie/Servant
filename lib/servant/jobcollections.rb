module Servant
  class JobCollections
    attr_accessor :path
    
    def initialize
      @path = nil
      @jobs = []
    end
    
    def add(job)
      path = File.join(@path, job + ".rb")
      data = IO.read(path)
            
      eval(data, Mixin::Command.get_binding)

      Mixin::Command.push_config(job)
    end
  end
end