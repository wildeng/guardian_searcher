# frozen_string_literal: true

module GuardianSearcher
  class Base
    include Faraday
    attr_reader :api_key
    attr_accessor :base_uri

    def initialize(api_key: nil)
      @base_uri = "https://content.guardianapis.com"

      raise GuardianApyKeyError unless api_key

      @api_key = api_key
    end

    # Options needs to be passed following Guardian API docs
    def search(q, options = {})
      opt = build_options(options)

      url = @base_uri + "/search?q=#{q}&#{opt}&api-key=#{@api_key}"
      Faraday.get(url)
    end

    def search_sections(q, options = {})
      opt = build_options(options)
      url = @base_uri + "/sections?q=#{q}&#{opt}&api-key=#{@api_key}"
      Faraday.get(url)
    end

    private

    def build_options(options)
      return {} if options.empty?

      opt = ""
      options.each do |key, value|
        # TODO: log a proper message if a key is not supported but continue with the ops building
        next unless valid_option?(key)
        opt += "&#{map_option(key)}=#{value}"
      end
    end

    def valid_option?(option)
      %i[from_date to_date page_size page].include?(option)
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
