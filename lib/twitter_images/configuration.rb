module TwitterImages
  class Configuration
    attr_reader   :options, :requester
    attr_accessor :search, :directory, :amount

    def initialize
      @requester = Requester.new
    end

    def prepare(options)
      check_auth
      set_directory(options[:path])
      get_search(options[:term])
      get_amount(options[:amount])
      start
    end

    private

    def check_auth
      unless File.exist?(ENV["HOME"] + "/.twitter_imagesrc")
        raise StandardError, "No configuration file was found, please run `twitter_images -auth`"
      end
    end

    def set_directory(dir)
      @directory = File.expand_path(dir)
      raise StandardError, "Directory doesn't exist" unless Dir.exist?(@directory)
      Dir.chdir(@directory)
    end

    def get_search(term)
      @search = term.chomp.gsub(/\s/, "%20").gsub(/\#/, "%23")
      raise StandardError, "The search string is empty" if @search.empty?
    end

    def get_amount(number)
      @amount = number.to_i
      raise StandardError, "The number is too small" if @amount <= 0
    end

    def start
      requester.start(@search, @amount)
    end
  end
end
