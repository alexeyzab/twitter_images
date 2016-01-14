require "codeclimate-test-reporter"
CodeClimate::TestReporter.configure do |config|
  config.git_dir = `git rev-parse --show-toplevel`.strip
end
CodeClimate::TestReporter.start
require "rspec"
require "webmock/rspec"
require "twitter_images"

WebMock.disable_net_connect!(allow_localhost: true, allow: %w{codeclimate.com})

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, /api.twitter.com/).with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'OAuth oauth_consumer_key="0ZVaXLwlzqgEt2PJuXKk9lmWq", oauth_nonce="jRhT5890B1QHws8G3EGtAb9p4kVqaeIMx2KaF9o7Law", oauth_signature_method="HMAC-SHA1",  oauth_token="2709018354-WuB4E05IsiY7DO55rVF7kUaNuI8qAl5682Myg0O", oauth_version="1.0"', 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(status: 200, body: "stubbed response", headers: {})

    stub_request(:get, "http://pbs.twimg.com/media/123456789000000.jpg:large").
      with(:headers => {'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
      to_return(:status => 200, :body => "", :headers => {})

  end
end
