module Visdiff
  class Revision
    attr_reader :identifier, :images
    def initialize identifier, images
      @identifier = identifier
      @images = images
    end

    def submit!
      response = Request.post('revisions', attributes)
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

    def attributes
      {
        revision: {
          identifier: identifier,
          image_attributes: images.map do |image|
            {signature: image.signature}
          end
        }
      }
    end
  end
end
