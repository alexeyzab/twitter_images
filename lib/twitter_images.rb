require "twitter_images/version"
require "twitter_images/ti_configure"
require 'rubygems'
require 'open-uri'
require 'fileutils'
require 'json'
require 'oauth'
require 'ruby-progressbar'


module TwitterImages
  class ImageDownloader
    attr_accessor :images, :settings

    def initialize(settings, images)
      @settings = settings
      @images = images
    end

    def download
      settings.prepare
      images.search
    end
  end

  class Images
    attr_accessor :images
    attr_reader :settings

    def initialize(settings)
      @images = images
      @settings = settings
    end

    def search
      get_images
      save_images
    end

    private

    def get_images
      @images = settings.output.inspect.scan(/http:\/\/pbs.twimg.com\/media\/\w+\.(?:jpg|png|gif)/)
      raise StandardError, "Couldn't find any images" unless @images
    end

    def make_absolute(href, root)
      URI.parse(root).merge(URI.parse(href)).to_s
    end

    def save_images
      progressbar = ProgressBar.create(:total => images.count)
      images.each do |src|
        uri = make_absolute(src, settings.search)
        File.open(File.basename(uri), 'wb'){ |f| f.write(open(uri).read) }
        progressbar.increment
      end
    end
  end

  class Settings
    attr_accessor :search, :directory, :output, :consumer_key, :access_token,
      :address, :request, :http, :response

    def initialize()
      @search = search
      @directory = directory
      @output = output
      @consumer_key = consumer_key
      @access_token = access_token
      @address = address
      @request = request
      @http = http
      @response = response
    end

    def prepare
      get_directory
      change_dir
      get_search
      establish_connection
    end

    def establish_connection
      setup_address
      setup_http
      build_request
      issue_request
      get_output
    end

    private

    def setup_credentials
      TwitterImages::Configure_credentials.setup_credentials
    end

    def setup_http
      # Set up Net::HTTP to use SSL, which is required by Twitter.
      @http = Net::HTTP.new(address.host, address.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def build_request
      # Build the request and authorize it with OAuth.
      @request = Net::HTTP::Get.new(address.request_uri)
      request.oauth!(http, consumer_key, access_token)
    end

    def issue_request
      # Issue the request and return the response.
      http.start
      @response = http.request(request)
    end

    def get_output
      @output = JSON.parse(response.body)
    end

    def setup_address
      @address = URI("https://api.twitter.com/1.1/search/tweets.json?q=%23#{search}&mode=photos&count=100")
    end

    def get_directory
      puts "Please enter the absolute path to the directory to save the images in: "
      @directory = gets.chomp
      raise StandardError, "Directory doesn't exist" unless Dir.exists?(@directory)
    end

    def change_dir
      Dir.chdir(@directory)
    end

    def get_search
      puts "Please enter the search terms: "
      @search = gets.chomp.gsub(/\s/, "%20")
    end
  end

  if $0 == __FILE__
    settings = Settings.new
    images = Images.new(settings)
    ImageDownloader.new(settings, images).download
  end
end
