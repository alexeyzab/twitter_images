require "spec_helper"

describe TwitterImages::Requester do
  requester = TwitterImages::Requester.new

  describe "#initialize" do
    it "doesn't raise an error when initialized" do
      expect { TwitterImages::Requester.new }.not_to raise_error
    end
  end

  describe "#start" do
    it "passes on the download message to downloader" do
      allow(requester).to receive(:send_requests).with("cats", 200)

      expect(requester.downloader).to receive(:download)
      expect(STDOUT).to receive(:puts).with("Getting links to the images...")

      requester.start("cats", 200)
    end
  end

  describe "#send_requests" do
    it "calls the right methods to get links" do
      expect(requester).to receive(:configure_client)
      expect(requester).to receive(:get_tweets).with("cats", -1)
      expect(requester).to receive(:trim_links).with(-1)

      requester.send_requests("cats", -1)
    end
  end

  describe "#configure_client" do
    it "calls the right methods to configure the client" do
      requester.send(:configure_client)

      expect(requester.client).to be_a(Twitter::REST::Client)
    end
  end

  describe "#get_tweets" do
    it "calls the right method after getting the tweet objects" do
      requester.client = double("client")
      allow(requester.client).to receive_message_chain(:search, :take, :each)

      expect(requester).to receive(:get_max_id)
      expect(requester).to receive(:get_links)

      requester.send(:get_tweets, "cats", 2)
    end
  end

  describe "#get_max_id" do
    it "gets the smallest id minus one for each tweet batch" do
      tweet_1 = double("Tweet", id: 124)
      tweet_2 = double("Tweet", id: 123)
      tweets = [tweet_1, tweet_2]

      requester.send(:get_max_id, tweets)

      expect(requester.max_id).to eq(122)
    end
  end

  describe "#get_links" do
    it "pulls the image links out of the tweet objects" do
      requester.links.clear
      inner_double_1 = double("inner", media_url: "link1")
      inner_double_2 = double("inner", media_url: "link2")
      tweet_1 = double("Tweet", media: [inner_double_1])
      tweet_2 = double("Tweet", media: [inner_double_2])
      tweets = [tweet_1, tweet_2]

      requester.send(:get_links, tweets)

      expect(requester.links).to eq(["link1", "link2"])
    end

    it "makes sure the links are unique" do
      requester.links.clear
      inner_double_1 = double("inner", media_url: "link1")
      inner_double_2 = double("inner", media_url: "link2")
      tweet_1 = double("Tweet", media: [inner_double_1])
      tweet_2 = double("Tweet", media: [inner_double_2])
      tweet_3 = double("Tweet", media: [inner_double_2])
      tweets = [tweet_1, tweet_2, tweet_3]

      requester.send(:get_links, tweets)

      expect(requester.links).to eq(["link1", "link2"])
    end
  end

  describe "#trim_links" do
    it "trims the excess links" do
      requester.links = Array.new(3) { "link" }

      requester.send(:trim_links, 2)

      expect(requester.links.count).to eq(2)
    end
  end
end
