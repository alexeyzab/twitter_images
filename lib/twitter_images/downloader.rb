module TwitterImages
  class Downloader
    attr_accessor :images
    attr_reader :configuration

    def initialize(configuration)
      @images = images
      @configuration = configuration
    end

    def download
      get_images
      save_images
    end

    private

    def get_images
      @images = configuration.output.inspect.scan(/http:\/\/pbs.twimg.com\/media\/\w+\.(?:jpg|png|gif)/)
      raise StandardError, "Couldn't find any images" unless @images.count > 0
    end

    def save_images
      progressbar = ProgressBar.create(:total => images.count)
      images.each do |src|
        File.open(File.basename(src), "wb") { |f| f.write(open(src + ":large").read) }
        progressbar.increment
      end
    end
  end
end
