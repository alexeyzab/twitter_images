require "spec_helper"

describe TwitterImages::Downloader do

  describe "#initialize" do
    it "doesn't raise an error when initialized with a response" do
      response = double("response")
      downloader = TwitterImages::Downloader.new(response)

      expect(downloader.response).to eq(response)
    end

    it "throws an error if initialized with no configuration" do
      expect { TwitterImages::Downloader.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#download" do
    it "makes sure the proper methods get called" do
      response = double("response")
      downloader = TwitterImages::Downloader.new(response)
      allow(downloader).to receive(:get_output)
      allow(downloader).to receive(:parse_output)
      allow(downloader).to receive(:save_images)

      downloader.download

      expect(downloader).to have_received(:get_output)
      expect(downloader).to have_received(:parse_output)
      expect(downloader).to have_received(:save_images)
    end
  end

  describe "#get_output" do
    it "parses the JSON of the response into a hash" do
      response = double("response", :body => "{\"id\":1,\"media\":{\"media_url_http\":\"https://pbs.twimg.com/media/name.jpg\"}}")
      downloader = TwitterImages::Downloader.new(response)

      downloader.send(:get_output)

      expect(downloader.output).to be_a(Hash)
    end
  end

  describe "#parse_output" do
    it "gets the links to the images" do
      response = double("response", :body => "{\"id\":1,\"media\":{\"media_url_https\":\"https://pbs.twimg.com/media/name.jpg\"}}")
      downloader = TwitterImages::Downloader.new(response)
      downloader.send(:get_output)

      downloader.send(:parse_output)
      result = downloader.images

      expect(result).to eq(["https://pbs.twimg.com/media/name.jpg"])
    end

    it "raises an error if there are no images found" do
      response = double("response", :body => "{\"id\":1,\"media\":{\"media_url_https\":\"https://pbs.twimg.com/media/name.jpg\"}}")
      downloader = TwitterImages::Downloader.new(response)
      downloader.output = {}

      expect { downloader.send(:parse_output) }.to raise_error(StandardError)
    end
  end

  describe "#save_images" do
    it "saves images to a folder" do
      response = double("response", :body => "{\"id\":1,\"media\":{\"media_url_https\":\"https://pbs.twimg.com/media/name.jpg\"}}")
      configuration = TwitterImages::Configuration.new
      downloader = TwitterImages::Downloader.new(response)
      downloader.images = ["http://pbs.twimg.com/media/123456789000000.jpg"]
      data = File.open("spec/fixture.jpg", "r")
      allow(downloader).to receive(:open).and_return(data)

      configuration.directory = "#{Dir.getwd}/spec"
      configuration.send(:change_directory)

      downloader.send(:save_images)

      expect(File).to exist("#{Dir.getwd}/123456789000000.jpg")
    end
  end

end
