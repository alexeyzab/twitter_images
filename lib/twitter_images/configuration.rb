module TwitterImages
  class Configuration
    attr_accessor :search, :directory

    def prepare
      set_directory
      get_search
      Requester.new(@search).start
    end

    def set_directory
      puts "Please enter the directory to save the images in: "
      @directory = gets.chomp
      raise StandardError, "Directory doesn't exist" unless directory_exists?
      change_directory
    end

    def directory_exists?
      Dir.exist?(File.expand_path(@directory))
    end

    def change_directory
      Dir.chdir(File.expand_path(@directory))
    end

    def get_search
      puts "Please enter the search terms: "
      @search = gets.chomp.gsub(/\s/, "%20")
      raise StandardError, "The search string is empty" if @search.empty?
    end
  end
end
