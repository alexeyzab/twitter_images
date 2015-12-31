module TwitterImages
  class CLI
    attr_accessor :downloader, :configuration

    def initialize(configuration, downloader)
      @configuration = configuration
      @downloader = downloader
    end

    def run
      configuration.prepare
      downloader.download
    end
  end
end
