module Visdiff
  class Image
    attr_reader :fullpath

    def initialize fullpath
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
      Request.put("images/#{signature}", image: {image: upload_io})
    end

    def upload_io
      Faraday::UploadIO.new(fullpath, 'image/png')
    end
  end
end
