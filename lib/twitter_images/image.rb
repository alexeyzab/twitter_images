module TwitterImages
  class Image
    attr_accessor :images
    attr_reader :settings

    def initialize(settings)
      @images = images
      @settings = settings
    end

    def search
      get_images
      save_images
    end

    private

    def get_images
      @images = settings.output.inspect.scan(/http:\/\/pbs.twimg.com\/media\/\w+\.(?:jpg|png|gif)/)
      raise StandardError, "Couldn't find any images" unless @images
    end

    def make_absolute(href, root)
      URI.parse(root).merge(URI.parse(href)).to_s
    end

    def save_images
      progressbar = ProgressBar.create(:total => images.count)
      images.each do |src|
        uri = make_absolute(src, settings.search)
        File.open(File.basename(uri), 'wb'){ |f| f.write(open(uri).read) }
        progressbar.increment
      end
    end
  end
end
