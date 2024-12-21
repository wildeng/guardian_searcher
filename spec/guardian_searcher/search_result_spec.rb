# frozen_string_literal: true

require "spec_helper"

RSpec.describe GuardianSearcher::SearchResult do
  context "when searching", :vcr do
    let(:search_term) { "politics" }
    describe ".parse_results" do
      it "returns a SearchResult object" do
        VCR.use_cassette("returns_a_200") do
          searcher = GuardianSearcher::Search.new(api_key: "test")
          response = searcher.search(search_term)
          expect(response.status).to eq(200)

          search_result = GuardianSearcher::SearchResult.parse_results(body: response.body)
          expect(search_result.is_a?(GuardianSearcher::SearchResult)).to eq(true)
        end
      end
    end

    describe ".parse_with_codes" do
      it "returns a Search object" do
        VCR.use_cassette("returns_a_200") do
          searcher = GuardianSearcher::Search.new(api_key: "test")
          response = searcher.search(search_term)
          expect(response.status).to eq(200)

          search_result = GuardianSearcher::SearchResult.parse_with_codes(response: response)
          expect(search_result.is_a?(GuardianSearcher::SearchResult)).to eq(true)
        end
      end

      it "raises an exception for 500" do
        VCR.use_cassette("returns_a_500") do
          searcher = GuardianSearcher::Search.new(api_key: "test")
          response = searcher.search("test", { "from_date": "okidoki" })
          expect(response.status).to eq(500)

          expect { GuardianSearcher::SearchResult.parse_with_codes(response: response) }.to raise_error(
            GuardianSearcher::GuardianInternalServerError,
            JSON.parse(response.body)["message"]
          )
        end
      end

      it "raises an exception for 400" do
        VCR.use_cassette("returns_a_400") do
          searcher = GuardianSearcher::Search.new(api_key: "test")
          response = searcher.search("test", { "from_date": "okidoki" })
          expect(response.status).to eq(400)

          expect { GuardianSearcher::SearchResult.parse_with_codes(response: response) }.to raise_error(
            GuardianSearcher::GuardianBadRequestError,
            JSON.parse(response.body)["message"]
          )
        end
      end

      it "raises an exception for unknown" do
        VCR.use_cassette("returns_a_407") do
          searcher = GuardianSearcher::Search.new(api_key: "test")
          response = searcher.search("test", { "from_date": "okidoki" })
          expect(response.status).to eq(407)

          expect { GuardianSearcher::SearchResult.parse_with_codes(response: response) }.to raise_error(
            GuardianSearcher::GuardianUnknownError,
            JSON.parse(response.body)["message"]
          )
        end
      end

      it "raises an exception for 401" do
        VCR.use_cassette("returns_a_401") do
          searcher = GuardianSearcher::Search.new(api_key: "xxxtest")
          response = searcher.search(search_term)
          expect(response.status).to eq(401)

          expect { GuardianSearcher::SearchResult.parse_with_codes(response: response) }.to raise_error(
            GuardianSearcher::GuardianUnauthorizedError,
            JSON.parse(response.body)["message"]
          )
        end
      end
    end
  end
end
