require "spec_helper"

describe TwitterImages::CLI do
  configuration = TwitterImages::Configuration.new
  images = TwitterImages::Image.new(configuration)
  cli = TwitterImages::CLI.new(configuration, images)

  describe "#initialize" do
    it "doesn't throw an error when initialized with configuration and images" do
      expect(cli.configuration).to eq(configuration)
      expect(cli.images).to eq(images)
    end

    it "will throw an error if initialized with no configuration" do
      expect { TwitterImages::CLI.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#download" do
    it "downloads the images when the configuration is set" do
      allow(configuration).to receive(:prepare)
      allow(images).to receive(:search)

      cli.download

      expect(configuration).to have_received(:prepare)
      expect(images).to have_received(:search)
    end
  end
end

