module TwitterImages
  class ImageDownloader
    attr_accessor :images, :settings

    def initialize(settings, images)
      @settings = settings
      @images = images
    end

    def download
      settings.prepare
      images.search
    end
  end
end
