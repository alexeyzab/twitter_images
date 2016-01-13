module TwitterImages
  class Downloader
    attr_accessor :output, :images

    def download(all_links)
      save_images(all_links)
    end

    private

    def write_file(filename, data)
      file = File.new(File.basename(filename), "wb")
      file.write(data)
      file.close
    end

    def save_images(all_links)
      progressbar = ProgressBar.create(:total => all_links.count)
      hydra = Typhoeus::Hydra.new

      all_links.each do |src|
        request = Typhoeus::Request.new(src + ":large")
        request.on_complete do |response|
          write_file(src, response.body)
          progressbar.increment
        end
        hydra.queue request
      end
      hydra.run
      puts "Downloaded #{all_links.count} pictures!"
    end
  end

end
