require "spec_helper"

describe TwitterImages::CLI do
  configuration = TwitterImages::Configuration.new
  downloader = TwitterImages::Downloader.new(configuration)
  cli = TwitterImages::CLI.new(configuration, downloader)

  describe "#initialize" do
    it "doesn't throw an error when initialized with a configuration and a downloader" do
      expect(cli.configuration).to eq(configuration)
      expect(cli.downloader).to eq(downloader)
    end

    it "will throw an error if initialized with no configuration" do
      expect { TwitterImages::CLI.new() }.to raise_error(ArgumentError)
    end
  end

  describe "#download" do
    it "downloads the images when the configuration is set" do
      allow(configuration).to receive(:prepare)
      allow(downloader).to receive(:download)

      cli.run

      expect(configuration).to have_received(:prepare)
      expect(downloader).to have_received(:download)
    end
  end
end

