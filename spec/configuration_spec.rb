require "spec_helper"

describe TwitterImages::Configuration do
  configuration = TwitterImages::Configuration.new()
  ENV["CONSUMER_KEY"] = "key"
  ENV["CONSUMER_SECRET"] = "key_secret"
  ENV["ACCESS_TOKEN"] = "token"
  ENV["ACCESS_SECRET"] = "token_secret"

  describe "#initialize" do
    it "gets initialized with no arguments" do
      expect { TwitterImages::Configuration.new() }.not_to raise_error
    end
  end

  describe "#prepare" do
    it "calls the right methods to prepare the configuration" do
      allow(configuration).to receive(:setup_credentials).and_return(:true)
      allow(configuration).to receive(:get_directory).and_return(:true)
      allow(configuration).to receive(:change_directory).and_return(:true)
      allow(configuration).to receive(:get_search).and_return(:true)
      allow(configuration).to receive(:establish_connection).and_return(:true)

      configuration.prepare

      expect(configuration).to have_received(:setup_credentials)
      expect(configuration).to have_received(:get_directory)
      expect(configuration).to have_received(:change_directory)
      expect(configuration).to have_received(:get_search)
      expect(configuration).to have_received(:establish_connection)
    end
  end

  describe "#establish_connection" do
    it "calls the right method to establish the connection" do
      allow(configuration).to receive(:setup_address).and_return(:true)
      allow(configuration).to receive(:setup_http).and_return(:true)
      allow(configuration).to receive(:build_request).and_return(:true)
      allow(configuration).to receive(:issue_request).and_return(:true)
      allow(configuration).to receive(:get_output).and_return(:true)

      configuration.establish_connection

      expect(configuration).to have_received(:setup_address)
      expect(configuration).to have_received(:setup_http)
      expect(configuration).to have_received(:build_request)
      expect(configuration).to have_received(:issue_request)
      expect(configuration).to have_received(:get_output)
    end
  end

  describe "#setup_credentials" do
    it "sets up the credentials" do
      allow(configuration).to receive(:check_env).and_return(true)

      configuration.send(:setup_credentials)

      expect(configuration.consumer_key.key).to eq("key")
      expect(configuration.consumer_key.secret).to eq("key_secret")
      expect(configuration.access_token.token).to eq("token")
      expect(configuration.access_token.secret).to eq("token_secret")
    end
  end

  describe "#check_env" do
    it "returns true if the credentials are found in ENV" do
      result = configuration.send(:check_env)

      expect(result).to eq(true)
    end

    it "tells you to the credentials have not been set up otherwise" do
      ENV.delete("CONSUMER_KEY")
      ENV.delete("CONSUMER_SECRET")
      ENV.delete("ACCESS_TOKEN")
      ENV.delete("ACCESS_SECRET")

      result = configuration.send(:check_env)

      expect(result).to eq("The credentials have not been correctly set up in your ENV")

      ENV["CONSUMER_KEY"] = "key"
      ENV["CONSUMER_SECRET"] = "key_secret"
      ENV["ACCESS_TOKEN"] = "token"
      ENV["ACCESS_SECRET"] = "token_secret"
    end
  end

  describe "#get_directory" do
    it "gets the directory" do
      allow(configuration).to receive(:gets).and_return("#{Dir.getwd}\n")

      configuration.send(:get_directory)

      expect(configuration.directory).to eq("#{Dir.getwd}")
    end

    it "raises the StandardError when the entered directory does not exist" do
      allow(configuration).to receive(:gets).and_return("\n")

      expect { configuration.send(:get_directory) }.to raise_error(StandardError)
    end
  end

  describe "#get_search" do
    it "turns the search term into parameters" do
      allow(configuration).to receive(:gets).and_return("Hi there\n")

      configuration.send(:get_search)

      expect(configuration.search).to eq "Hi%20there"
    end

    it "raises a StandardError if the search is empty" do
      allow(configuration).to receive(:gets).and_return("\n")

      expect { configuration.send(:get_search) }.to raise_error(StandardError)
    end
  end
end
