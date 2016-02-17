require "spec_helper"

describe TwitterImages::Authorizer do
  authorizer = TwitterImages::Authorizer.new

  describe "#authorize" do
    it "calls the right methods to authorize the app" do
      expect(authorizer).to receive(:get_request_token)
      expect(authorizer).to receive(:visit_url)
      expect(authorizer).to receive(:get_pin)
      expect(authorizer).to receive(:authorize_with_pin)
      expect(authorizer).to receive(:handle_credentials)

      authorizer.authorize
    end
  end

  describe "#get_request_token" do
    it "gets the request token" do
      oauth = double("Consumer", :get_request_token => 123456789)
      credentials = TwitterImages::Credentials.new
      allow(credentials).to receive(:consumer_key).and_return("key")
      allow(credentials).to receive(:consumer_secret).and_return("secret")
      allow(OAuth::Consumer).to receive(:new).and_return(oauth)

      authorizer.send(:get_request_token)

      expect(authorizer.request_token).to eq(123456789)
    end
  end

  describe "#visit_url" do
    it "prints the url to visit" do
      double_token = double("Token", :token => 123456789)
      allow(authorizer).to receive(:request_token).and_return(double_token)
      allow(Launchy).to receive(:open)

      expect(STDOUT).to receive(:puts).with("Please visit this url in your browser: https://twitter.com/oauth/authorize?oauth_token=123456789&oauth_callback=oob")

      authorizer.send(:visit_url)
    end
  end

  describe "#get_pin" do
    it "stores your pin in a variable" do
      allow(authorizer).to receive(:gets).and_return("12345678\n")
      authorizer.send(:get_pin)

      expect(authorizer.pin).to eq("12345678")
    end
  end

  describe "#authorize_with_pin" do
    it "gets the token credentials" do
      double_token = double("Token", :get_access_token => 123456789)
      allow(authorizer).to receive(:request_token).and_return(double_token)

      authorizer.send(:authorize_with_pin)

      expect(authorizer.access_token_object).not_to be(nil)
    end
  end
end
