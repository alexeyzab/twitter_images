require "spec_helper"

describe TwitterImages::Requester do

  describe "#initialize" do
    it "doesn't raise an error when initialized" do
      expect { TwitterImages::Requester.new }.not_to raise_error
    end
  end

  describe "#start" do
    it "passes on the download message to downloader" do
      requester = TwitterImages::Requester.new
      allow(requester).to receive(:get_links).with("cats", 200)

      expect(requester.downloader).to receive(:download)

      requester.start("cats", 200)
    end
  end

  describe "#get_links" do
    it "calls the right methods to get links" do
      requester = TwitterImages::Requester.new
      expect(requester).to receive(:configure_request).with("cats")
      expect(requester).to receive(:parse)
      expect(requester.parser).to receive(:trim_links).with(-1)

      requester.get_links("cats", -1)
    end
  end

  describe "#configure_request" do
    it "calls the right methods to configure request" do
      requester = TwitterImages::Requester.new

      expect(requester).to receive(:setup_address).with("cats")
      expect(requester).to receive(:setup_https)
      expect(requester).to receive(:issue_request)

      requester.send(:configure_request, "cats")
    end
  end

  describe "#setup_address" do
    it "creates a URI without max_id" do
      requester = TwitterImages::Requester.new
      result = requester.send(:setup_address, "cats")

      expect(result.inspect).to eq("#<URI::HTTPS https://api.twitter.com/1.1/search/tweets.json?q=cats&result_type=recent&count=100>")
    end

    it "adds the max_id parameter to the address if it's present" do
      requester = TwitterImages::Requester.new
      requester.parser.max_id = 123456
      result = requester.send(:setup_address, "cats")

      expect(result.inspect).to eq("#<URI::HTTPS https://api.twitter.com/1.1/search/tweets.json?q=cats&result_type=recent&count=100&max_id=123456>")
    end
  end

  describe "#consumer_key" do
    it "generates the consumer key object from the consumer key and secret" do
      requester = TwitterImages::Requester.new
      result = requester.send(:consumer_key)

      expect(result).to be_a(OAuth::Consumer)
    end
  end

  describe "#access_token" do
    it "generates the access token object from the access token and secret" do
      requester = TwitterImages::Requester.new
      result = requester.send(:access_token)

      expect(result).to be_a(OAuth::Token)
    end
  end

  describe "#setup_https" do
    it "sets up the http" do
      requester = TwitterImages::Requester.new
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https).to be_a(Net::HTTP)
    end

    it "enables the use of SSL" do
      requester = TwitterImages::Requester.new
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https.use_ssl?).to eq(true)
    end

    it "sets the right SSL verify mode" do
      requester = TwitterImages::Requester.new
      requester.address = double("address", :host => "api.twitter.com", :port => 443)

      requester.send(:setup_https)

      expect(requester.https.verify_mode).to eq(0)
    end
  end

  describe "#parse" do
    it "sends parse to parser" do
      requester = TwitterImages::Requester.new

      expect(requester.parser).to receive(:parse)

      requester.send(:parse)
    end
  end

  describe "#trim_links" do
    it "calls the Parser's method" do
      requester = TwitterImages::Requester.new
      expect(requester.parser).to receive(:trim_links).with(10)

      requester.send(:trim_links, 10)
    end
  end
end
