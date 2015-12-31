require "spec_helper"

describe TwitterImages::Downloader do
  configuration = TwitterImages::Configuration.new
  downloader = TwitterImages::Downloader.new(configuration)

  describe "#initialize" do
    it "doesn't raise an error when initialized with configuration" do
      expect(downloader.configuration).to eq(configuration)
    end

    it "will throw an error if initialized with no configuration" do
      expect { TwitterImages::Downloader.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#search" do
    it "makes sure the proper methods get called" do
      allow(downloader).to receive(:get_images)
      allow(downloader).to receive(:save_images)

      downloader.download

      expect(downloader).to have_received(:get_images)
      expect(downloader).to have_received(:save_images)
    end

    it "raises an error when the configuration is not specified" do
      expect { TwitterImages::Downloader.new.search }.to raise_error(ArgumentError)
    end
  end

  describe "#get_images" do
    it "gets the links to the downloader" do
      allow(configuration).to receive_message_chain(:output, :inspect).and_return("bla bla http://pbs.twimg.com/media/name.jpg")

      downloader.send(:get_images)
      result = downloader.images

      expect(result).to eq(["http://pbs.twimg.com/media/name.jpg"])
    end

    it "raises an error if there are no downloader found" do
      downloader.images = nil
      expect { downloader.send(:get_images) }.to raise_error(StandardError)
    end
  end
end

