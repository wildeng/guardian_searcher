# frozen_string_literal: true

require "json"

RSpec.describe GuardianSearcher::ArticleResult do
  let(:article_body) do
    {
      response: {
        status: "ok",
        content: {
          id: "world/2024/jun/28/test-article",
          type: "article",
          sectionId: "world",
          sectionName: "World news",
          webTitle: "Test Article",
          webUrl: "https://www.theguardian.com/world/2024/jun/28/test-article"
        }
      }
    }.to_json
  end

  let(:faraday_response) do
    instance_double(
      Faraday::Response,
      status: 200,
      body: article_body
    )
  end

  describe ".parse_results" do
    it "returns a Content object from a valid response body" do
      result = GuardianSearcher::ArticleResult.parse_results(body: article_body)
      expect(result).to be_a(GuardianSearcher::Content)
      expect(result.web_title).to eq("Test Article")
      expect(result.id).to eq("world/2024/jun/28/test-article")
    end

    it "returns nil if body is nil" do
      expect(GuardianSearcher::ArticleResult.parse_results(body: nil)).to be_nil
    end
  end

  describe ".parse_with_codes" do
    it "returns a Content object on 200" do
      result = GuardianSearcher::ArticleResult.parse_with_codes(response: faraday_response)
      expect(result).to be_a(GuardianSearcher::Content)
      expect(result.web_title).to eq("Test Article")
    end

    it "raises GuardianBadRequestError on 400" do
      error_body = { message: "bad request" }.to_json
      response = instance_double(Faraday::Response, status: 400, body: error_body)
      expect do
        GuardianSearcher::ArticleResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianBadRequestError, "bad request")
    end

    it "raises GuardianUnauthorizedError on 401" do
      error_body = { message: "unauthorized" }.to_json
      response = instance_double(Faraday::Response, status: 401, body: error_body)
      expect do
        GuardianSearcher::ArticleResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianUnauthorizedError, "unauthorized")
    end

    it "raises GuardianInternalServerError on 500" do
      error_body = { message: "internal error" }.to_json
      response = instance_double(Faraday::Response, status: 500, body: error_body)
      expect do
        GuardianSearcher::ArticleResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianInternalServerError, "internal error")
    end

    it "raises GuardianUnknownError on unknown status" do
      response = instance_double(Faraday::Response, status: 418, body: "{}")
      expect do
        GuardianSearcher::ArticleResult.parse_with_codes(response: response)
      end.to raise_error(GuardianSearcher::GuardianUnknownError)
    end

    it "raises GuardianSearcherUndefinedResponse if response is nil" do
      expect do
        GuardianSearcher::ArticleResult.parse_with_codes(response: nil)
      end.to raise_error(GuardianSearcher::GuardianSearcherUndefinedResponse)
    end
  end
end
