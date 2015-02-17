require 'visdiff/config'

module Visdiff
  class Client
    attr_reader :config

    def initialize(config=Visdiff.config)
      @config = config
    end

    def revision identifier, images=[], description=nil
      revision = Revision.new(identifier, images, description)
      revision.client = self
      yield revision if block_given?
      revision
    end

    def submit_revision revision
      post('revisions', revision: revision.attributes)
    end

    def submit_image image
      put("images/#{image.signature}", image: image.attributes)
    end

    private

    def post path, data
      parse(conn.post(path, request_data(data)))
    end

    def put path, data
      parse(conn.put(path, request_data(data)))
    end

    def request_data data
      {api_key: api_key}.merge(data)
    end

    def api_key
      config.api_key || raise("visdiff api key not configured")
    end

    def base_url
      "#{config.base_url}/api"
    end

    def conn
      config.connection
    end

    def parse response
      raise response.body unless response.success?
      JSON.parse(response.body)
    end
  end
end
