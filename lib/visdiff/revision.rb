module Visdiff
  class Revision
    attr_reader :identifier, :images, :description
    attr_accessor :client

    def initialize identifier, images=[], description=nil
      @identifier = identifier
      @images = images
      @description = description
    end

    def add_image identifier, filename
      image = Image.new(identifier, filename)
      image.client = client
      @images << image
    end

    def submit!
      response = client.submit_revision(self)

      missing_images = []
      response['images'].each do |rimg|
        missing_images << rimg['signature'] unless rimg['url']
      end
      puts "Uploading #{missing_images.length} new images (#{response['images'].length} total)"

      images.each do |image|
        next unless missing_images.include?(image.signature)
        client.submit_image(image)
      end
    end

    def attributes
      {
        identifier: identifier,
        image_attributes: images.map do |image|
          {identifier: image.identifier, description: description, signature: image.signature}
        end
      }
    end
  end
end
