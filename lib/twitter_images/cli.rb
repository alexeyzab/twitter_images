module TwitterImages
  class CLI
    attr_accessor :images, :configuration

    def initialize(configuration, images)
      @configuration = configuration
      @images = images
    end

    def download
      configuration.prepare
      images.search
    end
  end
end
