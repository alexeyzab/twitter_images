module TwitterImages
  class Authorizer
    attr_reader :oauth, :request_token, :pin, :access_token_object, :access_token, :access_secret

    def authorize
      get_request_token
      visit_url
      get_pin
      authorize_with_pin
      set_credentials
      puts "Authorization successful. Credentials have been written to #{ENV['HOME']}/.twitter_imagesrc"
    end

    def access_token
      if File.exist?(ENV["HOME"] + "/.twitter_imagesrc")
        @access_token = IO.readlines(ENV["HOME"] + "/.twitter_imagesrc")[0].chomp
      end
    end

    def access_secret
      if File.exist?(ENV["HOME"] + "/.twitter_imagesrc")
        @access_secret = IO.readlines(ENV["HOME"] + "/.twitter_imagesrc")[1].chomp
      end
    end

    private

    def get_request_token
      @oauth = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => "https://api.twitter.com")
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

    def set_credentials
      File.open(ENV["HOME"] + "/.twitter_imagesrc", "w") do |file|
        file.puts(access_token_object.token)
        file.puts(access_token_object.secret)
        file.close
      end
    end
  end
end
