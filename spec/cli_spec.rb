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

  describe "#parse_command_line_options" do
    it "parses the global options" do
      ARGV = ["./test_pics", "#cats", "50"]
      cli = TwitterImages::CLI.new(ARGV)
      allow(cli).to receive_message_chain(:global_options, :parse!)
      expect(cli).to receive(:global_options)

      cli.send(:parse_command_line_options)
      ARGV.clear
    end

    it "assigns the options hash" do
      ARGV = ["./test_pics", "#cats", "50"]
      cli = TwitterImages::CLI.new(ARGV)

      cli.send(:parse_command_line_options)

      expect(cli.options).to eq({ :path => "./test_pics", :term => "#cats", :amount => "50" })
      ARGV.clear
    end
  end
end

