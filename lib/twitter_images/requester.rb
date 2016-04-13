module TwitterImages
  class Requester
    attr_reader   :downloader, :credentials, :search
    attr_accessor :client, :tweets, :links, :max_id

    def initialize
      @downloader = Downloader.new
      @credentials = Credentials.new
      @max_id = nil
      @tweets = []
      @links = []
    end

    def start(search, amount)
      puts "Getting links..."
      send_requests(search, amount)
      download(links)
    end

    def send_requests(search, amount)
      configure_client
      loop do
        get_tweets(search, amount)
        break if @links.count > amount
      end
      trim_links(amount)
    end

    private

    def configure_client
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = credentials.consumer_key
        config.consumer_secret = credentials.consumer_secret
        config.access_token = credentials.access_token
        config.access_token_secret = credentials.access_secret
      end
    end

    def get_tweets(search, amount)
      client.search(search, result_type: "recent", max_id: @max_id).take(amount).each do |tweet|
        @tweets << tweet
      end
      get_max_id(@tweets)
      get_links(@tweets)
    end

    def get_max_id(tweets)
      ids = []
      tweets.each do |tweet|
        ids << tweet.id
      end
      @max_id = ids.min - 1
    end

    def get_links(tweets)
      tweets.each do |tweet|
        if !tweet.media.empty?
          @links << tweet.media[0].media_url.to_s
          @links.uniq!
        end
      end
    end

    def trim_links(amount)
      @links = @links.slice(0...amount)
    end

    def download(links)
      downloader.download(links)
    end
  end
end
