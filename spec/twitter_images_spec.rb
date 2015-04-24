require 'spec_helper'

describe TwitterImages do
  it 'has a version number' do
    expect(TwitterImages::VERSION).not_to be nil
  end

  describe TwitterImages::ImageDownloader do
    let(:settings) { TwitterImages::Settings.new }
    let(:images) { TwitterImages::Images.new(settings) }
    let(:imagedownloader) { TwitterImages::ImageDownloader.new(settings, images) }

    describe "#initialize" do
      it "doesn't throw an error when initialized with settings and images" do
        expect(imagedownloader.settings).to eq(settings)
        expect(imagedownloader.images).to eq(images)
      end

      it "will throw an error if initialized with no settings" do
        expect { TwitterImages::ImageDownloader.new() }.to raise_error
      end
    end

    describe "#download" do
      it "downloads the images when the settings are set" do
        allow(settings).to receive(:prepare).and_return(true)
        allow(images).to receive(:search).and_return(true)
        expect(imagedownloader.download).to eq(true)
      end

      it "raises an error if the settings and images are not set" do
        expect { imagedownloader.download }.to raise_error
      end
    end
  end

  describe TwitterImages::Images do
    let(:settings) { TwitterImages::Settings.new }
    let(:images) { TwitterImages::Images.new(settings) }
    describe "#initialize" do
      it "doesn't raise an error when initialized with settings" do
        expect(images.settings).to eq(settings)
      end

      it "will throw an error if initialized with no settings" do
        expect { TwitterImages::Images.new() }.to raise_error
      end
    end

    describe "#search" do
      it "gets the empty array back when the settings are specified" do
        expect(images.search).to eq([])
      end

      it "raises an error when the settings are not specified" do
        expect { TwitterImages::Images.new.search }.to raise_error
      end
    end
  end
end
