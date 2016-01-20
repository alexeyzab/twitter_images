require "spec_helper"

describe TwitterImages::Requester do

  describe "#initialize" do
    it "doesn't raise an error when initialized with a downloader and a parser" do
      downloader = double("Downloader")
      parser = double("Parser")

      expect { TwitterImages::Requester.new(downloader, parser) }.not_to raise_error
    end

    it "throws an error if initialized with no arguments" do
      expect { TwitterImages::Requester.new }.to raise_error(ArgumentError)
    end
  end

  describe "#start" do
    it "passes on the download message to downloader" do
      downloader = double("Downloader", :download => true)
      parser = double("Parser", :parsed_links => true)
      requester = TwitterImages::Requester.new(downloader, parser)
      allow(requester).to receive(:get_links).with("cats", 200)

      requester.start("cats", 200)

      expect(downloader).to have_received(:download)
    end
  end

  describe "#get_links" do
    it "calls the trim_links after getting enough links" do
      downloader = double("Downloader")
      parser = double("Parser", max_id: 1, parse: true, parsed_links: ["link", "link"])
      requester = TwitterImages::Requester.new(downloader, parser)

      expect(requester).to receive(:trim_links)

      requester.get_links("cats", 1)
    end
  end

  describe "#setup_address" do
    it "sets up the URI" do
      downloader = double("Downloader")
      parser = double("Parser", max_id: 1)
      requester = TwitterImages::Requester.new(downloader, parser)
      result = requester.send(:setup_address, "cats")

      expect(result).to be_a(URI::HTTPS)
    end

    it "adds the max_id parameter to the address if it's present" do
      downloader = double("Downloader")
      parser = double("Parser", max_id: 123456)
      requester = TwitterImages::Requester.new(downloader, parser)
      result = requester.send(:setup_address, "cats")

      expect(result.inspect).to eq("#<URI::HTTPS https://api.twitter.com/1.1/search/tweets.json?q=%23cats&result_type=recent&count=100&max_id=123456>")
    end
  end

  describe "#consumer_key" do
    it "generates the consumer key object from the consumer key and secret" do
      downloader = double("Downloader")
      parser = double("Parser")
      requester = TwitterImages::Requester.new(downloader, parser)
      result = requester.send(:consumer_key)

      expect(result).to be_a(OAuth::Consumer)
    end
  end

  describe "#access_token" do
    it "generates the access token object from the access token and secret" do
      downloader = double("Downloader")
      parser = double("Parser")
      requester = TwitterImages::Requester.new(downloader, parser)
      result = requester.send(:access_token)

      expect(result).to be_a(OAuth::Token)
    end
  end

  describe "#check_env" do
    it "returns true if the credentials are found in ENV" do
      downloader = double("Downloader")
      parser = double("Parser")
      requester = TwitterImages::Requester.new(downloader, parser)
      ENV["CONSUMER_KEY"] = "key"
      ENV["CONSUMER_SECRET"] = "key_secret"
      ENV["ACCESS_TOKEN"] = "token"
      ENV["ACCESS_SECRET"] = "token_secret"
      result = requester.send(:check_env)

      expect(result).to eq(true)
    end

    it "tells you to the credentials have not been set up otherwise" do
      downloader = double("Downloader")
      parser = double("Parser")
      requester = TwitterImages::Requester.new(downloader, parser)
      ENV.delete("CONSUMER_KEY")
      ENV.delete("CONSUMER_SECRET")
      ENV.delete("ACCESS_TOKEN")
      ENV.delete("ACCESS_SECRET")

      expect(STDOUT).to receive(:puts).with("The credentials have not been correctly set up in your ENV")

      requester.send(:check_env)
    end
  end

  describe "#setup_https" do
    it "sets up the http" do
      downloader = double("Downloader")
      parser = double("Parser")
      requester = TwitterImages::Requester.new(downloader, parser)
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https).to be_a(Net::HTTP)
    end

    it "enables the use of SSL" do
      downloader = double("Downloader")
      parser = double("Parser")
      requester = TwitterImages::Requester.new(downloader, parser)
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https.use_ssl?).to eq(true)
    end

    it "sets the right SSL verify mode" do
      downloader = double("Downloader")
      parser = double("Parser")
      requester = TwitterImages::Requester.new(downloader, parser)
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https.verify_mode).to eq(0)
    end
  end
end
