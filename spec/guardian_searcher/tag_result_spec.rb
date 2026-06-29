# frozen_string_literal: true

require "json"

RSpec.describe GuardianSearcher::TagResult do
  let(:tag_body) do
    {
      response: {
        status: "ok",
        total: 2,
        startIndex: 1,
        pageSize: 10,
        currentPage: 1,
        pages: 1,
        results: [
          { id: "football/football", webTitle: "Football", type: "keyword" },
          { id: "sport/sport", webTitle: "Sport", type: "keyword" }
        ]
      }
    }.to_json
  end

  describe ".parse_results" do
    it "returns a SearchResult from a valid body" do
      result = GuardianSearcher::TagResult.parse_results(body: tag_body)
      expect(result).to be_a(GuardianSearcher::SearchResult)
      expect(result.results.size).to eq(2)
      expect(result.results.first["webTitle"]).to eq("Football")
    end

    it "returns nil if body is nil" do
      expect(GuardianSearcher::TagResult.parse_results(body: nil)).to be_nil
    end
  end

  describe ".parse_with_codes" do
    it "returns a SearchResult on 200" do
      response = instance_double(Faraday::Response, status: 200, body: tag_body)
      result = GuardianSearcher::TagResult.parse_with_codes(response: response)
      expect(result).to be_a(GuardianSearcher::SearchResult)
    end

    it "raises GuardianBadRequestError on 400" do
      error_body = { message: "bad request" }.to_json
      response = instance_double(Faraday::Response, status: 400, body: error_body)
      expect do
        GuardianSearcher::TagResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianBadRequestError, "bad request")
    end

    it "raises GuardianUnauthorizedError on 401" do
      error_body = { message: "unauthorized" }.to_json
      response = instance_double(Faraday::Response, status: 401, body: error_body)
      expect do
        GuardianSearcher::TagResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianUnauthorizedError, "unauthorized")
    end

    it "raises GuardianInternalServerError on 500" do
      error_body = { message: "internal error" }.to_json
      response = instance_double(Faraday::Response, status: 500, body: error_body)
      expect do
        GuardianSearcher::TagResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianInternalServerError, "internal error")
    end

    it "raises GuardianUnknownError on unknown status" do
      response = instance_double(Faraday::Response, status: 418, body: "{}")
      expect do
        GuardianSearcher::TagResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianUnknownError)
    end

    it "raises GuardianSearcherUndefinedResponse if response is nil" do
      expect do
        GuardianSearcher::TagResult.parse_with_codes(response: nil)
      end.to raise_error(GuardianSearcher::GuardianSearcherUndefinedResponse)
    end
  end
end
