require "spec_helper"

describe TwitterImages::Configuration do
  configuration = TwitterImages::Configuration.new

  describe "#prepare" do
    it "calls the right methods to prepare the configuration" do
      requester = double("Requester", :new => true, :start => true)
      allow(TwitterImages::Requester).to receive(:new).and_return(requester)
      allow(configuration).to receive(:set_directory)
      allow(configuration).to receive(:get_search)

      configuration.prepare

      expect(configuration).to have_received(:set_directory)
      expect(configuration).to have_received(:get_search)
      expect(requester).to have_received(:start)
    end
  end

  describe "#set_directory" do
    it "sets the directory" do
      allow(configuration).to receive(:gets).and_return("#{Dir.getwd}\n")

      configuration.send(:set_directory)

      expect(configuration.directory).to eq("#{Dir.getwd}")
    end

    it "raises a StandardError when the entered directory does not exist" do
      allow(configuration).to receive(:gets).and_return("/idontexist\n")
      allow(configuration).to receive(:directory_exists?).and_return(false)

      expect { configuration.send(:set_directory) }.to raise_error(StandardError)
    end

    it "correctly parses the tilde sign" do
      current_directory = Dir.getwd
      allow(configuration).to receive(:gets).and_return("~\n")

      expect { configuration.send(:set_directory) }.not_to raise_error

      Dir.chdir(current_directory)
    end
  end

  describe "#get_search" do
    it "turns the search term into parameters" do
      allow(configuration).to receive(:gets).and_return("Hi there\n")

      configuration.send(:get_search)

      expect(configuration.search).to eq "Hi%20there"
    end

    it "raises a StandardError if the search is empty" do
      allow(configuration).to receive(:gets).and_return("\n")

      expect { configuration.send(:get_search) }.to raise_error(StandardError)
    end
  end
end
