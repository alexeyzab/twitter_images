require "spec_helper"

describe TwitterImages::Requester do
  requester = TwitterImages::Requester.new("cats")

  describe "#initialize" do
    it "doesn't raise an error when initialized with a downloader" do
      downloader = double("Downloader")
      requester = TwitterImages::Requester.new(downloader)

      expect(requester.downloader).to eq(downloader)
    end

    it "throws an error if initialized with no downloader" do
      expect { TwitterImages::Requester.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#start" do
    it "passes on the download message to downloader" do
      downloader = double("Downloader", :download => true)
      requester = TwitterImages::Requester.new(downloader)

      requester.start("cats", 200)

      expect(downloader).to have_received(:download)
    end
  end

  describe "#get_json" do
    it "accumulates the image links in an array" do
      downloader = double("Downloader", :download => true)
      requester = TwitterImages::Requester.new(downloader)

      requester.get_json("cats", 200)

      expect(requester.response).to be_a(Array)
    end
  end

  describe "#setup_address" do
    it "sets up the URI" do
      result = requester.send(:setup_address, "cats")

      expect(result). to be_a(URI::HTTPS)
    end
  end

  describe "#consumer_key" do
    it "generates the consumer key object from the consumer key and secret" do
      result = requester.send(:consumer_key)

      expect(result).to be_a(OAuth::Consumer)
    end
  end

  describe "#access_token" do
    it "generates the access token object from the access token and secret" do
      result = requester.send(:access_token)

      expect(result).to be_a(OAuth::Token)
    end
  end

  describe "#check_env" do
    it "returns true if the credentials are found in ENV" do
      ENV["CONSUMER_KEY"] = "key"
      ENV["CONSUMER_SECRET"] = "key_secret"
      ENV["ACCESS_TOKEN"] = "token"
      ENV["ACCESS_SECRET"] = "token_secret"
      result = requester.send(:check_env)

      expect(result).to eq(true)
    end

    it "tells you to the credentials have not been set up otherwise" do
      ENV.delete("CONSUMER_KEY")
      ENV.delete("CONSUMER_SECRET")
      ENV.delete("ACCESS_TOKEN")
      ENV.delete("ACCESS_SECRET")

      expect(STDOUT).to receive(:puts).with("The credentials have not been correctly set up in your ENV")

      result = requester.send(:check_env)
    end
  end

  describe "#setup_https" do
    it "sets up the http" do
      downloader = double("Downloader")
      requester = TwitterImages::Requester.new(downloader)
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https).to be_a(Net::HTTP)
    end

    it "enables the use of ssl" do
      downloader = double("Downloader")
      requester = TwitterImages::Requester.new(downloader)
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https.use_ssl?).to eq(true)
    end

    it "sets the right SSL verify mode" do
      downloader = double("Downloader")
      requester = TwitterImages::Requester.new(downloader)
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https.verify_mode).to eq(1)
    end
  end
end
