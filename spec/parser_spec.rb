require "spec_helper"

describe TwitterImages::Parser do

  describe "#initialize" do
    it "doesn't raise an error when initialized with a response" do
      expect { TwitterImages::Parser.new() }.not_to raise_error
    end
  end

  describe "#parse" do
    it "parses the response to an array" do
      response = double("response", body: "{\"statuses\": [{\"id\":123, \"media\": [{\"media_url\": \"https://pbs.twimg.com/media/first.jpg\"}]}, {\"id\":124,\"media\": [{\"media_url\": \"https://pbs.twimg.com/media/second.gif\"}]}, {\"id\": 125,\"media\": [{\"media_url\":\"https://pbs.twimg.com/media/third.png\"}]}]}")
      parser = TwitterImages::Parser.new

      parser.parse(response)

      expect(parser.parsed_links).to be_a(Array)
    end
  end

  describe "#trim_links" do
    it "trims the links if there are more of them than needed" do
      parser = TwitterImages::Parser.new
      parser.parsed_links = ["https://pbs.twimg.com/media/first.jpg", "https://pbs.twimg.com/media/second.gif", "https://pbs.twimg.com/media/third.png" ]
      amount = 2

      parser.send(:trim_links, amount)

      expect(parser.parsed_links.count).to eq(amount)
    end
  end

  describe "#get_max_id" do
    it "gets the minimum id minus one of the parsed tweets for this request" do
      parser = TwitterImages::Parser.new
      parsed = { "statuses"=> [ { "id" => 123, "media" => [ { "media_url" => "https://pbs.twimg.com/media/name.jpg" } ] }, { "id" => 124, "media" => [ { "media_url" => "https://pbs.twimg.com/media/another.png" } ] } ] }

      parser.send(:get_max_id, parsed)

      expect(parser.max_id).to eq(122)
    end
  end

  describe "#collect_responses" do
    it "creates an array of image links" do
      parser = TwitterImages::Parser.new
      hash = { "statuses" => [ { "id" => 123, "media" => [ { "media_url" => "https://pbs.twimg.com/media/name.jpg" } ] }, { "id" => 124, "media" => [ { "media_url" => "https://pbs.twimg.com/media/another.png" } ] }, { "id" => 125, "media" => [ { "media_url" => "https://pbs.twimg.com/media/another.png" } ] } ] }

      result = parser.send(:collect_responses, hash)

      expect(result).to eq(["https://pbs.twimg.com/media/name.jpg", "https://pbs.twimg.com/media/another.png"])
    end
  end
end
