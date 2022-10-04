# frozen_string_literal: true

RSpec.describe GuardianSearcher::Base do
  context("when initialize") do
    it "returns an error if api key is not set" do
      expect { GuardianSearcher::Search.new }.to raise_error(GuardianSearcher::GuardianApyKeyError)
    end

    it "sets an api_key variable if api_key is set" do
      searcher = GuardianSearcher::Search.new(api_key: "test")
      expect(searcher.api_key).to eq("test")
    end
  end

  describe "#search", :vcr do
    let(:described_class) { GuardianSearcher::Search.new(api_key: "test") }
    let(:search_term) { "politics" }

    it "returns a 200" do
      VCR.use_cassette("returns_a_200") do
        response = described_class.search(search_term)
        expect(response.status).to eq(200)
      end
    end
  end
end
