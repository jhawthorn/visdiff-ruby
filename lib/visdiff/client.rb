module Visdiff
  class Client
    def initialize base_url, project
      @base_url = base_url
      @project = project
    end

    def post path, data
      parse conn.post(path, data)
    end

    def put path, data
      parse conn.put(path, data)
    end

    private

    def url
      "#{@base_url}/projects/#{@project}/"
    end

    def conn
      Faraday.new(:url => url) do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    def parse response
      raise response.body unless response.success?
      JSON.parse(response.body)
    end
  end
end
