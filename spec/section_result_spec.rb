# frozen_string_literal: true

RSpec.describe(GuardianSearcher::SectionResult) do
  context "when searching", :vcr do
    describe(".parse_result") do
      let(:search_edition_term) { "politics" }
      it("returns a search result object") do
        VCR.use_cassette("edition_returns_200") do
          searcher = GuardianSearcher::Search.new(api_key: "test")
          response = searcher.search_sections(search_edition_term)
          expect(response.status).to eq(200)
          search_result = GuardianSearcher::SectionResult.parse_results(body: response.body)
          expect(search_result.is_a?(GuardianSearcher::SearchResult)).to eq(true)
        end
      end
    end
  end
end
