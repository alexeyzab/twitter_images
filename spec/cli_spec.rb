require "spec_helper"

describe TwitterImages::CLI do

  describe "#initialize" do
    it "sets up the configuration" do
      cli = TwitterImages::CLI.new(ARGV)
      expect(cli.configuration).to be_a(TwitterImages::Configuration)
    end
  end

  describe "#run" do
    it "runs the preparation for the configuration" do
      cli = TwitterImages::CLI.new(ARGV)
      allow(cli.configuration).to receive(:prepare)
      allow(cli).to receive(:parse_command_line_options)

      cli.run

      expect(cli).to have_received(:parse_command_line_options)
      expect(cli.configuration).to have_received(:prepare)
    end
  end
end

