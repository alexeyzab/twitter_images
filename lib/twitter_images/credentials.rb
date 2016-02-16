module TwitterImages
  class Credentials
    require "twitter_images/consumer"

    attr_reader :access_token_object
    attr_accessor :access_token, :access_secret

    def set(access_token_object)
      write_credentials(access_token_object)
      assign_credentials
    end

    def consumer_key
      Consumer.new.consumer_key
    end

    def consumer_secret
      Consumer.new.consumer_secret
    end

    private

    def write_credentials(access_token_object)
      File.open(ENV["HOME"] + "/.twitter_imagesrc", "w") do |file|
        file.puts(access_token_object.token)
        file.puts(access_token_object.secret)
        file.close
      end
    end

    def assign_credentials
      if File.exist?(ENV["HOME"] + "/.twitter_imagesrc")
        @access_token = IO.readlines(ENV["HOME"] + "/.twitter_imagesrc")[0].chomp
        @access_secret = IO.readlines(ENV["HOME"] + "/.twitter_imagesrc")[1].chomp
      end
    end
  end
end
