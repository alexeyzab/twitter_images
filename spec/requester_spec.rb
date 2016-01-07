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
      allow(requester).to receive(:set_address)
      allow(requester).to receive(:setup_credentials)
      allow(requester).to receive(:setup_https)
      allow(requester).to receive(:build_request)
      allow(requester).to receive(:issue_request)
      allow(TwitterImages::Downloader).to receive_message_chain(:new, :download)

      requester.start

      expect(requester).to have_received(:set_address)
      expect(requester).to have_received(:setup_credentials)
      expect(requester).to have_received(:setup_https)
      expect(requester).to have_received(:build_request)
      expect(requester).to have_received(:issue_request)
    end
  end

  describe "#setup_credentials" do
    it "sets up the credentials" do
      allow(requester).to receive(:check_env).and_return(true)
      ENV["CONSUMER_KEY"] = "key"
      ENV["CONSUMER_SECRET"] = "key_secret"
      ENV["ACCESS_TOKEN"] = "token"
      ENV["ACCESS_SECRET"] = "token_secret"

      requester.send(:setup_credentials)

      expect(requester.consumer_key.key).to eq("key")
      expect(requester.consumer_key.secret).to eq("key_secret")
      expect(requester.access_token.token).to eq("token")
      expect(requester.access_token.secret).to eq("token_secret")
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
