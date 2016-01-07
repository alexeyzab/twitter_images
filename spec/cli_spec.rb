require "spec_helper"

describe TwitterImages::CLI do
  cli = TwitterImages::CLI.new

  describe "#initialize" do
    it "sets up the configuration" do
      expect(cli.configuration).to be_a(TwitterImages::Configuration)
    end
  end

  describe "#run" do
    it "runs the preparation for the configuration" do
      allow(cli.configuration).to receive(:prepare)

      cli.run

      expect(cli.configuration).to have_received(:prepare)
    end
  end
end

