module TwitterImages
  class Requester
    attr_reader   :consumer_key, :access_token, :downloader, :search, :parser, :authorizer
    attr_accessor :https, :address, :response

    def initialize
      @downloader = Downloader.new
      @parser = Parser.new
      @authorizer = Authorizer.new
    end

    def start(search, amount)
      get_links(search, amount)
      download
    end

    def get_links(search, amount)
      loop do
        configure_request(search)
        parse
        break if @parser.parsed_links.count > amount
      end
      trim_links(amount)
    end

    private

    def configure_request(search)
      setup_address(search)
      setup_https
      issue_request
    end

    def setup_address(search)
      unless parser.max_id.nil?
        @address = URI("https://api.twitter.com/1.1/search/tweets.json?q=#{search}&result_type=recent&count=100&max_id=#{parser.max_id}")
      else
        @address = URI("https://api.twitter.com/1.1/search/tweets.json?q=#{search}&result_type=recent&count=100")
      end
    end

    def consumer_key
      OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET)
    end

    def access_token
      OAuth::Token.new(authorizer.access_token, authorizer.access_secret)
    end

    def setup_https
      @https = Net::HTTP.new(address.host, address.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def issue_request
      request = Net::HTTP::Get.new(address.request_uri)
      request.oauth!(https, consumer_key, access_token)
      @https.start
      @response = https.request(request)
    end

    def parse
      parser.parse(response)
    end

    def trim_links(amount)
      parser.trim_links(amount)
    end

    def download
      downloader.download(parser.parsed_links)
    end
  end
end
