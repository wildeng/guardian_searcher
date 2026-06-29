# frozen_string_literal: true

module GuardianSearcher
  class Search < GuardianSearcher::Base
    def self.search_articles(q, options = {})
      searcher = GuardianSearcher::Search.new(api_key: ENV["guardian_api_key"])
      searcher.search(q, options)
    end

    def self.search_sections(q, options = {})
      searcher = GuardianSearcher::Search.new(api_key: ENV["guardian_api_key"])
      searcher.search_sections(q, options)
    end

    def self.find_article(id, options = {})
      searcher = GuardianSearcher::Search.new(api_key: ENV["guardian_api_key"])
      searcher.find_article(id, options)
    end
  end
end
