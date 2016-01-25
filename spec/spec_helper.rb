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
    stub_request(:get, "https://api.twitter.com/1.1/search/tweets.json?count=100&max_id=1&q=%23cats&result_type=recent").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>//, 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, "https://api.twitter.com/1.1/search/tweets.json?count=100&q=cats&result_type=recent").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>//, 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, "http://pbs.twimg.com/media/123456789000000.jpg:large").
      with(:headers => {'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end
