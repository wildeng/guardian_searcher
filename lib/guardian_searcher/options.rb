# frozen_string_literal: true

module GuardianSearcher
  class Options < Hash
    private attr_accessor :options

    def method_missing(method_name, *args, &blk)
      return options.[](method_name, &blk) if @options.key?(method_name)

      super(method_name, *args, &blk)
    end

    def respond_to_missing?(method_name, *args)
      @options.key?(method_name) || super(method_name, *args)
    end

    def initialize(options)
      raise OptionsNotHashError unless options.is_a?(Hash)

      @options = options
    end

    def build_options
      return {} if options.empty?

      opt = ""
      options.each do |key, value|
        valid_option?(key)
        opt += "&#{map_option(key)}=#{value}"
      end
    end

    def valid_option?(option)
      raise OptionsNotSupportedError unless %i[from_date to_date page_size page].include?(option)
    end

    def map_option(key)
      {
        from_date: "from-date",
        to_date: "to-date",
        page_size: "page-size",
        page: "page"
      }[key]
    end
  end
end
