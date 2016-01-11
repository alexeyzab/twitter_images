module TwitterImages
  class Requester
    attr_reader   :consumer_key, :access_token, :downloader, :search
    attr_accessor :https, :address, :response, :max_id, :links, :parsed_links

    def initialize(downloader)
      @downloader = downloader
      @all_responses = []
      @parsed_links = 0
    end

    def start(search, amount)
      check_env
      get_json(search, amount)
      download
    end

    def get_json(search, amount)
      loop do
        setup_address(search)
        setup_https
        issue_request
        parse_response
        break if parsed_links > amount
      end
    end

    private

    def setup_address(search)
      unless @max_id.nil?
        @address = URI("https://api.twitter.com/1.1/search/tweets.json?q=%23#{search}&result_type=recent&count=100&max_id=#{@max_id}")
      else
        @address = URI("https://api.twitter.com/1.1/search/tweets.json?q=%23#{search}&result_type=recent&count=100")
      end
    end

    def consumer_key
      OAuth::Consumer.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])
    end

    def access_token
      OAuth::Token.new(ENV["ACCESS_TOKEN"], ENV["ACCESS_SECRET"])
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
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def issue_request
      # Build the request and authorize it with OAuth
      request = Net::HTTP::Get.new(address.request_uri)
      request.oauth!(https, consumer_key, access_token)
      # Issue the request and return the response.
      @https.start
      @response = https.request(request)
    end

    def parse_response
      filtered = JSON.parse(@response.body)
      get_max_id(filtered)
      collect_responses(filtered)
      count_links(filtered)
    end

    def get_max_id(filtered)
      ids = []
      filtered["statuses"].each do |tweet|
        ids << tweet["id"]
      end
      @max_id = ids.min - 1
    end

    def collect_responses(filtered)
      @all_responses += filtered.collect { |_k, v| v }
    end

    def count_links(filtered)
      @parsed_links += filtered.inspect.scan(/https:\/\/pbs.twimg.com\/media\/\w+\.(?:jpg|png|gif)/).uniq.count
    end

    def download
      downloader.download(@all_responses)
    end
  end
end
