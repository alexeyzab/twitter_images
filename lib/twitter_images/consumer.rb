module TwitterImages
  class Consumer
    def consumer_key
      ENV["CONSUMER_KEY"]
    end

    def consumer_secret
      ENV["CONSUMER_SECRET"]
    end
  end
end
