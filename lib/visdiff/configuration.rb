module Visdiff
  class Configuration
    attr_accessor :base_uri, :project

    def initialize
      @base_url = "http://127.0.0.1:3000/"
    end
  end
end
