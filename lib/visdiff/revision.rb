module Visdiff
  class Revision
    attr_reader :identifier, :images
    def initialize identifier, images
      @identifier = identifier
      @images = images
    end

    def submit!
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
