# frozen_string_literal: true

require "spec_helper"

RSpec.describe GuardianSearcher::SearchResult do
  context ".parse_results", :vcr do
    it "returns a Search object" do
      VCR.use_cassette("returns_a_200") do
        searcher = GuardianSearcher::Search.new(api_key: "test")
        expect(searcher.is_a?(GuardianSearcher::Search)).to eq(true)
      end
    end

    it "returns a SearchResult object" do
      VCR.use_cassette("returns_a_200") do
        searcher = GuardianSearcher::Search.new(api_key: "test")

        expect(searcher.is_a?(GuardianSearcher::Search)).to eq(true)
      end
    end
  end
end
