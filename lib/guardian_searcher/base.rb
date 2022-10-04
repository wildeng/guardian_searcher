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
      Options.new(options).build_options
    end
  end
end
