module TwitterImages
  class Requester
    attr_reader   :downloader, :authorizer, :search
    attr_accessor :client, :tweets, :links, :max_id

    def initialize
      @downloader = Downloader.new
      @authorizer = Authorizer.new
      @max_id = nil
      @tweets = []
      @links = []
    end

    def start(search, amount)
      puts "Getting links to the pictures..."
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
        config.consumer_key = CONSUMER_KEY
        config.consumer_secret = CONSUMER_SECRET
        config.access_token = authorizer.access_token
        config.access_token_secret = authorizer.access_secret
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
