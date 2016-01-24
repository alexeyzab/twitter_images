require "spec_helper"

describe TwitterImages::Configuration do

  describe "#initialize" do
    it "gets initialized with a requester" do
      configuration = TwitterImages::Configuration.new

      expect(configuration.requester).to be_a(TwitterImages::Requester)
    end
  end

  describe "#prepare" do
    it "calls the right methods to prepare the configuration" do
      configuration = TwitterImages::Configuration.new
      options = { path: "./test_pics", term: "cats", amount: "150" }
      allow(configuration).to receive(:set_directory)
      allow(configuration).to receive(:get_search)
      allow(configuration).to receive(:get_amount)
      allow(configuration).to receive(:start)

      configuration.prepare(options)

      expect(configuration).to have_received(:set_directory).with("./test_pics")
      expect(configuration).to have_received(:get_search).with("cats")
      expect(configuration).to have_received(:get_amount).with("150")
      expect(configuration).to have_received(:start)
    end
  end

  describe "#set_directory" do
    it "sets the directory" do
      configuration = TwitterImages::Configuration.new

      configuration.send(:set_directory, "#{Dir.getwd}")

      expect(configuration.directory).to eq("#{Dir.getwd}")
    end

    it "raises a StandardError when the entered directory does not exist" do
      configuration = TwitterImages::Configuration.new
      allow(configuration).to receive(:directory_exists?).and_return(false)

      expect { configuration.send(:set_directory, "#{Dir.getwd}") }.to raise_error(StandardError, "Directory doesn't exist")
    end

    it "correctly parses the relative path" do
      configuration = TwitterImages::Configuration.new

      expect { configuration.send(:set_directory, "./") }.not_to raise_error
    end
  end

  describe "#get_search" do
    it "turns the search term into parameters" do
      configuration = TwitterImages::Configuration.new
      configuration.send(:get_search, "#blessed weekend")

      expect(configuration.search).to eq "%23blessed%20weekend"
    end

    it "raises a StandardError if the search is empty" do
      configuration = TwitterImages::Configuration.new

      expect { configuration.send(:get_search, "") }.to raise_error(StandardError, "The search string is empty")
    end
  end

  describe "#get_amount" do
    it "gets the amount of images to download as an integer" do
      configuration = TwitterImages::Configuration.new

      configuration.send(:get_amount, "3")

      expect(configuration.amount).to eq(3)
    end

    it "raises a StandardError if the amount is 0 or less" do
      configuration = TwitterImages::Configuration.new

      expect { configuration.send(:get_amount, "0") }.to raise_error(StandardError, "The number is too small")
    end
  end

  describe "#start" do
    it "passes the right information to the Requester" do
      configuration = TwitterImages::Configuration.new
      configuration.search = "cats"
      configuration.amount = 200
      expect(configuration.requester).to receive(:start).with("cats", 200)

      configuration.send(:start)
    end
  end
end
