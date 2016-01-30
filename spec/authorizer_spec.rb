require "spec_helper"

describe TwitterImages::Authorizer do
  authorizer = TwitterImages::Authorizer.new

  describe "#access_token" do
    it "gets the access_token from the config file" do
      file = ["token\n", "secret\n"]
      allow(File).to receive(:exist?).and_return(true)
      allow(IO).to receive(:readlines).and_return(file)

      expect(authorizer.access_token).to eq("token")
    end
  end

  describe "#access_secret" do
    it "gets the access_secret from the config file" do
      file = ["token\n", "secret\n"]
      allow(File).to receive(:exist?).and_return(true)
      allow(IO).to receive(:readlines).and_return(file)

      expect(authorizer.access_secret).to eq("secret")
    end
  end

  describe "#get_request_token" do
    it "gets the request token" do
      oauth = double("Consumer", :get_request_token => 123456789)
      TwitterImages::Authorizer::CONSUMER_KEY = "key"
      TwitterImages::Authorizer::CONSUMER_SECRET = "secret"
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

  describe "#authorize_with_pin" do
    it "gets the token credentials" do
      double_token = double("Token", :get_access_token => 123456789)
      allow(authorizer).to receive(:request_token).and_return(double_token)

      authorizer.send(:authorize_with_pin)

      expect(authorizer.access_token_object).not_to be(nil)
    end
  end

  describe "#set_credentials" do
    it "writes the credentials to a config file" do
      access_token_object_double = double("Object", :token => "token", :secret => "secret")
      allow(authorizer).to receive(:access_token_object).and_return(access_token_object_double)
      fixture_file = File.read("spec/fixture_file")

      allow(File).to receive(:open).and_return(fixture_file)

      authorizer.send(:set_credentials)

      expect(IO.readlines("spec/fixture_file")[0].chomp).to eq("token")
      expect(IO.readlines("spec/fixture_file")[1].chomp).to eq("secret")
    end
  end
end
