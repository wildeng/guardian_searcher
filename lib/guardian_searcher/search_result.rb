# frozen_string_literal: true

require "json"

module GuardianSearcher
  class SearchResult
    attr_reader :results, :start, :page_size, :pages, :current_page

    def initialize(
      current_page: nil,
      results: nil,
      page_size: nil,
      pages: nil,
      start: nil
    )

      @current_page = current_page
      @results = results
      @page_size = page_size
      @pages = pages
      @start = start
    end

    def self.parse_results(body: nil)
      return unless body

      body = JSON.parse(body)
      response = body["response"]
      GuardianSearcher::SearchResult.new(
        current_page: response["currentPage"],
        results: response["results"],
        page_size: response["pageSize"],
        pages: response["pages"],
        start: response["startIndex"]
      )
    end
  end
end
