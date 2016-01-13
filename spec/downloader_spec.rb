require "spec_helper"

describe TwitterImages::Downloader do

  describe "#initialize" do
    it "initializes the downloader with no values passed in" do
      expect { TwitterImages::Downloader.new }.not_to raise_error
    end
  end

  describe "#download" do
    it "makes sure the proper methods get called" do
      all_links = double("all_links")
      downloader = TwitterImages::Downloader.new
      allow(downloader).to receive(:save_images).with(all_links)

      downloader.download(all_links)

      expect(downloader).to have_received(:save_images).with(all_links)
    end
  end

  describe "#save_images" do
    it "saves images to a folder" do
      downloader = TwitterImages::Downloader.new
      all_links  = ["http://pbs.twimg.com/media/123456789000000.jpg"]
      data = File.open("spec/fixture.jpg", "r")
      allow(downloader).to receive(:open).and_return(data)

      Dir.chdir("#{Dir.getwd}/spec")

      downloader.send(:save_images, all_links)

      expect(File).to exist("#{Dir.getwd}/123456789000000.jpg")
    end
  end

end
