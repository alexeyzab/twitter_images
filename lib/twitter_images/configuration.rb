module TwitterImages
  class Configuration
    attr_accessor :search, :directory, :output, :consumer_key, :access_token,
                  :address, :request, :http, :response

    def initialize()
      @search = search
      @directory = directory
      @output = output
      @consumer_key = consumer_key
      @access_token = access_token
      @address = address
      @request = request
      @http = http
      @response = response
    end

    def prepare
      setup_credentials
      get_directory
      change_directory
      get_search
      establish_connection
    end

    def establish_connection
      setup_address
      setup_http
      build_request
      issue_request
      get_output
    end

    private

    def setup_credentials
      check_env
      @consumer_key = OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])
      @access_token = OAuth::Token.new(ENV["ACCESS_TOKEN"], ENV["ACCESS_SECRET"])
    end

    def check_env
      if ENV.key?("CONSUMER_KEY") &&
         ENV.key?("CONSUMER_SECRET") &&
         ENV.key?("ACCESS_TOKEN") &&
         ENV.key?("ACCESS_SECRET")
        return true
      else
        return "The credentials have not been correctly set up in your ENV"
      end
    end

    def setup_http
      # Set up Net::HTTP to use SSL, which is required by Twitter.
      @http = Net::HTTP.new(address.host, address.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def build_request
      # Build the request and authorize it with OAuth.
      @request = Net::HTTP::Get.new(address.request_uri)
      request.oauth!(http, consumer_key, access_token)
    end

    def issue_request
      # Issue the request and return the response.
      http.start
      @response = http.request(request)
    end

    def get_output
      @output = JSON.parse(response.body)
    end

    def setup_address
      @address = URI("https://api.twitter.com/1.1/search/tweets.json?q=%23#{search}&mode=photos&count=100")
    end

    def get_directory
      puts "Please enter the directory to save the images in: "
      @directory = gets.chomp
      raise StandardError, "Directory doesn't exist" unless directory_exists?
    end

    def directory_exists?
      Dir.exists?(File.expand_path(@directory))
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
