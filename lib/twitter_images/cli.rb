module TwitterImages
  class CLI
    attr_accessor :configuration

    def initialize()
      @configuration = Configuration.new
    end

    def run
      configuration.prepare
    end
  end
end
