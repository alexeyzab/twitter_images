module TwitterImages
  class Downloader
    attr_accessor :response, :output, :images

    def initialize(response)
      @response = response
    end

    def download
      get_output
      parse_output
      save_images
    end

    private

    def get_output
      @output = JSON.parse(response.body)
    end

    def parse_output
      @images = output.inspect.scan(/https:\/\/pbs.twimg.com\/media\/\w+\.(?:jpg|png|gif)/)
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
