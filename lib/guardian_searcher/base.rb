# frozen_string_literal: true

module GuardianSearcher
  # Class that handles the basic functionality for the Guardian Reader gem
  class Base
    include Faraday

    attr_reader :api_key

    def initialize(api_key: nil)
      raise GuardianApyKeyError unless api_key

      @api_key = api_key
    end

    # Options needs to be passed following Guardian API docs
    def search(query, options = {})
      url = search_uri + query_string(query, options)
      Faraday.get(url)
    end

    def search_sections(query, options = {})
      url = sections_uri + query_string(query, options)
      Faraday.get(url)
    end

    def search_tags(query, options = {})
      url = tags_uri + query_string(query, options)
      Faraday.get(url)
    end

    def search_editions(query, options = {})
      url = editions_uri + query_string(query, options)
      Faraday.get(url)
    end

    private

    def base_uri
      "https://content.guardianapis.com"
    end

    def sections_uri
      "#{base_uri}/sections"
    end

    def search_uri
      "#{base_uri}/search"
    end

    def tags_uri
      "#{base_uri}/tags"
    end

    def editions_uri
      "#{base_uri}/editions"
    end

    def query_string(q, options = {})
      opt = build_options(options)
      "?q=#{q}&#{opt}&api-key=#{@api_key}"
    end

    def build_options(options)
      Options.new(options).build_options
    end
  end
end
