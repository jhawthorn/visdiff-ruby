module Visdiff
  class Image
    attr_reader :identifier, :fullpath
    attr_accessor :client

    def initialize identifier, fullpath
      @identifier = identifier
      @fullpath = fullpath
    end

    def basename
      File.basename(fullpath)
    end

    def signature
      @signature ||= IO.popen(["identify", "-format", "%#", '--', fullpath]) do |f|
        f.read
      end
    end

    def submit!
      @client.submit_image self
    end

    def attributes
      {image: {image: upload_io}}
    end

    def upload_io
      Faraday::UploadIO.new(fullpath, 'image/png')
    end
  end
end
