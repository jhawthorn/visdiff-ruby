require 'visdiff/config'

module Visdiff
  class Client
    attr_reader :config

    def initialize(config=Visdiff.config)
      @config = config
    end

    def submit_revision revision
      response = post('revisions', revision.attributes)
      missing_images = []
      response['images'].each do |rimg|
        missing_images << rimg['signature'] unless rimg['url']
      end
      puts "Uploading #{missing_images.length} new images (#{response['images'].length} total)"

      images.each do |image|
        next unless missing_images.include?(image.signature)
        image.submit!
      end
    end

    private

    def post path, data
      parse conn.post(path, data)
    end

    def put path, data
      parse conn.put(path, data)
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
