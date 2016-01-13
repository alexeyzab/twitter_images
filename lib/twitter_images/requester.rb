module TwitterImages
  class Requester
    attr_reader   :consumer_key, :access_token, :downloader, :search
    attr_accessor :https, :address, :response, :max_id, :all_responses

    def initialize(downloader)
      @downloader = downloader
      @all_responses = []
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
        break if all_responses.count > amount
      end
      trim_links(amount)
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

    def parse_response
      filtered = JSON.parse(@response.body)
      get_max_id(filtered)
      collect_responses(filtered)
    end

    def get_max_id(filtered)
      ids = []
      filtered["statuses"].each do |tweet|
        ids << tweet["id"]
      end
      @max_id = ids.min - 1
    end

    def collect_responses(filtered)
      @all_responses += filtered.inspect.scan(/https:\/\/pbs.twimg.com\/media\/\w+\.(?:jpg|png|gif)/)
      @all_responses.uniq!
    end

    def trim_links(amount)
      @all_responses = @all_responses.slice!(0...amount)
    end

    def download
      downloader.download(@all_responses)
    end
  end
end
