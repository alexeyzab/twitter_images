require "spec_helper"

describe TwitterImages::Configuration do

  describe "#initialize" do
    it "gets initialized with a requester" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)

      expect(configuration.requester).to eq(requester)
    end
  end

  describe "#prepare" do
    it "calls the right methods to prepare the configuration" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      allow(configuration).to receive(:set_directory)
      allow(configuration).to receive(:get_search)
      allow(configuration).to receive(:get_amount)
      allow(configuration).to receive(:start)

      configuration.prepare

      expect(configuration).to have_received(:set_directory)
      expect(configuration).to have_received(:get_search)
      expect(configuration).to have_received(:get_amount)
      expect(configuration).to have_received(:start)
    end
  end

  describe "#set_directory" do
    it "sets the directory" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      allow(configuration).to receive(:gets).and_return("#{Dir.getwd}\n")

      configuration.send(:set_directory)

      expect(configuration.directory).to eq("#{Dir.getwd}")
    end

    it "raises a StandardError when the entered directory does not exist" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      allow(configuration).to receive(:gets).and_return("/idontexist\n")
      allow(configuration).to receive(:directory_exists?).and_return(false)

      expect { configuration.send(:set_directory) }.to raise_error(StandardError, "Directory doesn't exist")
    end

    it "correctly parses the tilde sign" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      current_directory = Dir.getwd
      allow(configuration).to receive(:gets).and_return("~\n")

      expect { configuration.send(:set_directory) }.not_to raise_error

      Dir.chdir(current_directory)
    end
  end

  describe "#get_search" do
    it "turns the search term into parameters" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      allow(configuration).to receive(:gets).and_return("Hi there\n")

      configuration.send(:get_search)

      expect(configuration.search).to eq "Hi%20there"
    end

    it "raises a StandardError if the search is empty" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      allow(configuration).to receive(:gets).and_return("\n")

      expect { configuration.send(:get_search) }.to raise_error(StandardError, "The search string is empty")
    end
  end

  describe "#get_amount" do
    it "gets the amount of images to download as an integer" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      allow(configuration).to receive(:gets).and_return("3\n")

      configuration.send(:get_amount)

      expect(configuration.amount).to eq(3)
    end

    it "raises a StandardError if the amount is 0 or less" do
      requester = double("Requester")
      configuration = TwitterImages::Configuration.new(requester)
      allow(configuration).to receive(:gets).and_return("0\n")

      expect { configuration.send(:get_amount) }.to raise_error(StandardError, "The number is too small")
    end
  end

  describe "#start" do
    it "passes the right information to the Requester" do
      requester = double("Requester", :start => true)
      configuration = TwitterImages::Configuration.new(requester)
      configuration.search = "cats"
      configuration.amount = 200

      configuration.send(:start)

      expect(requester).to have_received(:start).with("cats", 200)
    end
  end
end
