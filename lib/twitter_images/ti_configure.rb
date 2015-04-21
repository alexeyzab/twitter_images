require "singleton"

class Configure
  include Singleton


  def setup_credentials
    puts "Please provide your twitter credentials now, first, enter your consumer key: "
    consumer_key = gets.chomp
    puts "Now your consumer secret: "
    consumer_secret = gets.chomp

    puts "Your access token: "
    access_token = gets.chomp
    puts "Finally, your access token secret: "
    access_secret = gets.chomp

    consumer_key = OAuth::Consumer.new(consumer_key, consumer_secret)

    access_token = OAuth::Token.new(access_token, access_secret)
  end
end
