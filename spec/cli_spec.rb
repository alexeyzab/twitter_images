require "spec_helper"

describe TwitterImages::CLI do

  describe "#initialize" do
    it "sets up the configuration" do
      configuration = double("configuration")
      cli = TwitterImages::CLI.new(configuration)
      expect(cli.configuration).to eq(configuration)
    end
  end

  describe "#run" do
    it "runs the preparation for the configuration" do
      configuration = double("configuration")
      cli = TwitterImages::CLI.new(configuration)
      allow(cli.configuration).to receive(:prepare)

      cli.run

      expect(cli.configuration).to have_received(:prepare)
    end
  end
end

