require "spec_helper"

describe TwitterImages::Credentials do
  credentials = TwitterImages::Credentials.new

  describe "#set" do
    it "calls the right methods to set the credentials" do
      access_token_object_double = double("Object", :token => "token", :secret => "secret")
      expect(credentials).to receive(:write_credentials).with(access_token_object_double)
      expect(credentials).to receive(:assign_credentials)

      credentials.set(access_token_object_double)
    end
  end

  describe "#consumer_key" do
    it "gets the consumer_key from the Consumer class" do
      consumer = double("Consumer", :consumer_key => "key")
      allow(TwitterImages::Consumer).to receive(:new).and_return(consumer)

      expect(credentials.consumer_key).to eq("key")
    end
  end

  describe "#consumer_secret" do
    it "gets the consumer_secret from the Consumer class" do
      consumer = double("Consumer", :consumer_secret => "secret")
      allow(TwitterImages::Consumer).to receive(:new).and_return(consumer)

      expect(credentials.consumer_secret).to eq("secret")
    end
  end

  describe "#write_credentials" do
    it "writes the credentials to a config file" do
      access_token_object_double = double("Object", :token => "token", :secret => "secret")
      fixture_file = File.read("spec/fixture_file")

      allow(File).to receive(:open).and_return(fixture_file)

      credentials.send(:write_credentials, access_token_object_double)

      expect(IO.readlines("spec/fixture_file")[0].chomp).to eq("token")
      expect(IO.readlines("spec/fixture_file")[1].chomp).to eq("secret")
    end
  end

  describe "#assign_credentials" do
    it "assigns the credentials from the config file" do
      file = ["token\n", "secret\n"]
      allow(File).to receive(:exist?).and_return(true)
      allow(IO).to receive(:readlines).and_return(file)

      credentials.send(:assign_credentials)

      expect(credentials.access_token).to eq("token")
      expect(credentials.access_secret).to eq("secret")
    end
  end
end
