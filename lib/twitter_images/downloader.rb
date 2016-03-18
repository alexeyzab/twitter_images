module TwitterImages
  class Downloader
    attr_accessor :output, :images

    def download(parsed_links)
      save_images(parsed_links)
    end

    private

    def write_file(filename, data)
      file = File.new(File.basename(filename), "wb")
      file.write(data)
      file.close
    end

    def save_images(parsed_links)
      progressbar = ProgressBar.create(:total => parsed_links.count, :format => "%a |%b>>%i| %p%% %t")
      hydra = Typhoeus::Hydra.new(max_concurrency: 120)

      parsed_links.each do |src|
        request = Typhoeus::Request.new(src + ":large")
        request.on_complete do |response|
          write_file(src, response.body)
          progressbar.increment
        end
        hydra.queue(request)
      end
      hydra.run
      puts "Downloaded #{parsed_links.count} pictures!"
    end
  end

end
