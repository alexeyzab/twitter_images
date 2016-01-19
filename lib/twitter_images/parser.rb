module TwitterImages
  class Parser
    attr_reader :response
    attr_accessor :parsed_links, :max_id

    def initialize
      @parsed_links = []
    end

    def parse(response)
      parsed = JSON.parse(response.body)
      get_max_id(parsed)
      collect_responses(parsed)
    end

    def trim_links(amount)
      @parsed_links = @parsed_links.slice!(0...amount)
    end

    private

    def get_max_id(parsed)
      ids = []
      parsed["statuses"].each do |tweet|
        ids << tweet["id"]
      end
      @max_id = ids.min - 1
    end

    def collect_responses(parsed)
      @parsed_links += parsed.inspect.scan(/https:\/\/pbs.twimg.com\/media\/\w+\.(?:jpg|png|gif)/)
      @parsed_links.uniq!
    end
  end
end
