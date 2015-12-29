require "spec_helper"

describe TwitterImages::Image do
  settings = TwitterImages::Configuration.new
  images = TwitterImages::Image.new(settings)

  describe "#initialize" do
    it "doesn't raise an error when initialized with settings" do
      expect(images.settings).to eq(settings)
    end

    it "will throw an error if initialized with no settings" do
      expect { TwitterImages::Image.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#search" do
    it "gets the empty array back when the settings are specified" do
      expect(images.search).to eq([])
    end

    it "raises an error when the settings are not specified" do
      expect { TwitterImages::Image.new.search }.to raise_error(ArgumentError)
    end
  end
end

