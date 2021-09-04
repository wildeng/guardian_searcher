# frozen_string_literal: true

require "json"

module GuardianSearcher
  class SectionResult
    attr_reader :results, :editions

    def initialize(
      results: nil,
      editions: nil
    )

      @results = results
      @editions = editions
    end

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
