module GuardianSearcher
  class OptionsNotHashError < StandardError; end
  class OptionsNotSupportedError < StandardError; end

  class Options < Hash
    private attr_accessor :options

    def method_missing(method_name, *args, &blk)
      return self.options.[](method_name, &blk) if @options.has_key?(method_name)
      super(method_name, *args, &blk)
    end
    
    def initialize(options)
      raise OptionsNotHashError unless options.is_a?(Hash)
      @options = options
    end
  end
end
