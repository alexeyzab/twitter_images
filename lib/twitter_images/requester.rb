module TwitterImages
  class Requester
    attr_reader   :address
    attr_accessor :search, :consumer_key, :access_token, :https,
                  :request, :response

    def initialize(search)
      @search = search
    end

    def start
      setup_credentials
      setup_https
      build_request
      issue_request
      Downloader.new(@response).download
    end

    private

    def address
      URI("https://api.twitter.com/1.1/search/tweets.json?q=%23#{search}&mode=photos&count=100")
    end

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
        puts "The credentials have not been correctly set up in your ENV"
      end
    end

    def setup_https
      # Set up Net::HTTP to use SSL, which is required by Twitter.
      @https = Net::HTTP.new(address.host, address.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def build_request
      # Build the request and authorize it with OAuth.
      @request = Net::HTTP::Get.new(address.request_uri)
      request.oauth!(https, consumer_key, access_token)
    end

    def issue_request
      # Issue the request and return the response.
      @https.start
      @response = https.request(request)
    end
  end
end
