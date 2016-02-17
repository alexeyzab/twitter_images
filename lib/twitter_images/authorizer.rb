module TwitterImages
  class Authorizer
    attr_reader :oauth, :request_token, :pin, :access_token_object

    def authorize
      get_request_token
      visit_url
      get_pin
      authorize_with_pin
      handle_credentials
      puts "Authorization successful. Credentials have been written to #{ENV['HOME']}/.twitter_imagesrc"
    end

    private

    def get_request_token
      @oauth = OAuth::Consumer.new(Credentials.new.consumer_key, Credentials.new.consumer_secret, :site => "https://api.twitter.com")
      @request_token = oauth.get_request_token
    end

    def visit_url
      puts "Please visit this url in your browser: https://twitter.com/oauth/authorize?oauth_token=#{request_token.token}&oauth_callback=oob"
      Launchy.open("https://twitter.com/oauth/authorize?oauth_token=#{request_token.token}&oauth_callback=oob")
    end

    def get_pin
      puts "Please enter your pin here: "
      @pin = gets.chomp
    end

    def authorize_with_pin
      @access_token_object = request_token.get_access_token(:oauth_verifier => @pin)
    end

    def handle_credentials
      Credentials.new.set(@access_token_object)
    end
  end
end
