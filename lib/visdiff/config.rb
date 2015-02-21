require 'faraday'

module Visdiff
  class Config
    attr_accessor :base_url, :api_key

    def initialize
    end

    attr_writer :connection
    def connection
      @connection ||= Faraday.new(:url => base_url) do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
