# frozen_string_literal: true

require "json"

RSpec.describe GuardianSearcher::EditionResult do
  let(:edition_body) do
    {
      response: {
        status: "ok",
        total: 1,
        startIndex: 1,
        pageSize: 10,
        currentPage: 1,
        pages: 1,
        results: [
          {
            id: "canada/canada",
            webTitle: "Canada",
            webUrl: "https://www.theguardian.com/canada",
            apiUrl: "https://content.guardianapis.com/canada",
            edition: "Canada"
          }
        ]
      }
    }.to_json
  end

  describe ".parse_results" do
    it "returns a SearchResult from a valid body" do
      result = GuardianSearcher::EditionResult.parse_results(body: edition_body)
      expect(result).to be_a(GuardianSearcher::SearchResult)
      expect(result.results.size).to eq(1)
      expect(result.results.first["edition"]).to eq("Canada")
    end

    it "returns nil if body is nil" do
      expect(GuardianSearcher::EditionResult.parse_results(body: nil)).to be_nil
    end
  end

  describe ".parse_with_codes" do
    it "returns a SearchResult on 200" do
      response = instance_double(Faraday::Response, status: 200, body: edition_body)
      result = GuardianSearcher::EditionResult.parse_with_codes(response: response)
      expect(result).to be_a(GuardianSearcher::SearchResult)
    end

    it "raises GuardianBadRequestError on 400" do
      error_body = { message: "bad request" }.to_json
      response = instance_double(Faraday::Response, status: 400, body: error_body)
      expect do
        GuardianSearcher::EditionResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianBadRequestError, "bad request")
    end

    it "raises GuardianUnauthorizedError on 401" do
      error_body = { message: "unauthorized" }.to_json
      response = instance_double(Faraday::Response, status: 401, body: error_body)
      expect do
        GuardianSearcher::EditionResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianUnauthorizedError, "unauthorized")
    end

    it "raises GuardianInternalServerError on 500" do
      error_body = { message: "internal error" }.to_json
      response = instance_double(Faraday::Response, status: 500, body: error_body)
      expect do
        GuardianSearcher::EditionResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianInternalServerError, "internal error")
    end

    it "raises GuardianUnknownError on unknown status" do
      response = instance_double(Faraday::Response, status: 418, body: "{}")
      expect do
        GuardianSearcher::EditionResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianUnknownError)
    end

    it "raises GuardianSearcherUndefinedResponse if response is nil" do
      expect do
        GuardianSearcher::EditionResult.parse_with_codes(response: nil)
      end.to raise_error(GuardianSearcher::GuardianSearcherUndefinedResponse)
    end
  end
end
