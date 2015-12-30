require "spec_helper"

describe TwitterImages::Image do
  configuration = TwitterImages::Configuration.new
  images = TwitterImages::Image.new(configuration)

  describe "#initialize" do
    it "doesn't raise an error when initialized with configuration" do
      expect(images.configuration).to eq(configuration)
    end

    it "will throw an error if initialized with no configuration" do
      expect { TwitterImages::Image.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#search" do
    it "makes sure the proper methods get called" do
      allow(images).to receive(:get_images)
      allow(images).to receive(:save_images)

      images.search

      expect(images).to have_received(:get_images)
      expect(images).to have_received(:save_images)
    end

    it "raises an error when the configuration is not specified" do
      expect { TwitterImages::Image.new.search }.to raise_error(ArgumentError)
    end
  end

  describe "#get_images" do
    it "gets the links to the images" do
      allow(configuration).to receive_message_chain(:output, :inspect).and_return("bla bla http://pbs.twimg.com/media/name.jpg")

      images.send(:get_images)
      result = images.images

      expect(result).to eq(["http://pbs.twimg.com/media/name.jpg"])
    end

    it "raises an error if there are no images found" do
      images.images = nil
      expect { images.send(:get_images) }.to raise_error(StandardError)
    end
  end
end

