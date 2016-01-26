module TwitterImages
  class CLI
    attr_reader :configuration, :options

    def initialize(argv)
      @argv = argv
      @configuration = Configuration.new
      @options = {}
    end

    def run
      parse_command_line_options
      configuration.prepare(@options)
    end

    private

    def parse_command_line_options
      global_options.parse!(@argv)
      @options[:path] = @argv[0]
      @options[:term] = @argv[1..-2].join
      @options[:amount] = @argv[-1]
    end

    def global_options
      OptionParser.new do |opts|
        opts.banner = "usage: twitter_images [-v | --version] [-h | --help] [options] [path] [search terms] [amount]"

        opts.on("-v", "--version", "Display the version and exit") do
          puts "Version: #{TwitterImages::VERSION}"
          exit
        end

        opts.on("-h", "--help", "Display this help message and exit") do
          puts opts
          exit
        end
      end
    end
  end
end
