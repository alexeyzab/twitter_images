module TwitterImages
  class Configuration
    attr_reader   :options, :requester
    attr_accessor :search, :directory, :amount

    def initialize
      @requester = Requester.new
    end

    def prepare(options)
      set_directory(options[:path])
      get_search(options[:term])
      get_amount(options[:amount])
      start
    end

    private

    def set_directory(dir)
      @directory = File.expand_path(dir)
      raise StandardError, "Directory doesn't exist" unless directory_exists?
      change_directory
    end

    def directory_exists?
      Dir.exist?(@directory)
    end

    def change_directory
      Dir.chdir(@directory)
    end

    def get_search(term)
      # @search = term.chomp.gsub(/\s/, "%20")
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
