# frozen_string_literal: true

require "json"

module GuardianSearcher
  # The class parses the search results and creates a new
  # SearchResults object with an editions variable
  class SectionResult
    def self.parse_results(body: nil)
      return unless body

      body = JSON.parse(body)
      response = body["response"]
      GuardianSearcher::SearchResult.new(
        results: response["results"],
        editions: response["results"][0]["editions"]
      )
    end
  end
end
