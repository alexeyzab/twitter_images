require "spec_helper"

describe TwitterImages::Requester do
  requester = TwitterImages::Requester.new("cats")

  describe "#initialize" do
    it "doesn't raise an error when initialized with a search" do
      expect(requester.search).to eq("cats")
    end

    it "throws an error if initialized with no search" do
      expect { TwitterImages::Requester.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#start" do
    it "calls the right methods to start the issue the request" do
      allow(requester).to receive(:setup_https)
      allow(requester).to receive(:build_request)
      allow(requester).to receive(:issue_request)
      allow(TwitterImages::Downloader).to receive_message_chain(:new, :download)

      requester.start

      expect(requester).to have_received(:setup_https)
      expect(requester).to have_received(:build_request)
      expect(requester).to have_received(:issue_request)
    end
  end

  describe "#address" do
    it "sets up the URI" do
      result = requester.send(:address)

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
end
