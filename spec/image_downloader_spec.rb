require "spec_helper"

describe TwitterImages::ImageDownloader do
  settings = TwitterImages::Configuration.new
  images = TwitterImages::Image.new(settings)
  imagedownloader = TwitterImages::ImageDownloader.new(settings, images)

  describe "#initialize" do
    it "doesn't throw an error when initialized with settings and images" do
      expect(imagedownloader.settings).to eq(settings)
      expect(imagedownloader.images).to eq(images)
    end

    it "will throw an error if initialized with no settings" do
      expect { TwitterImages::ImageDownloader.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#download" do
    it "downloads the images when the settings are set" do
      allow(settings).to receive(:prepare).and_return(true)
      allow(images).to receive(:search).and_return(true)
      expect(imagedownloader.download).to eq(true)
    end
  end
end

