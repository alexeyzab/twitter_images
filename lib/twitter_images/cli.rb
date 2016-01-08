module TwitterImages
  class CLI
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def run
      configuration.prepare
    end
  end
end
