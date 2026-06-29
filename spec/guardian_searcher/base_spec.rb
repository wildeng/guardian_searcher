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

    it "sends the api key as a request header, not in the URL" do
      searcher = GuardianSearcher::Search.new(api_key: "test")

      expect(Faraday).to receive(:get) do |url, _params, headers|
        expect(url).not_to include("api-key")
        expect(headers).to include("api-key" => "test")
      end

      searcher.search("politics")
    end

    it "URL-encodes special characters in the query parameter" do
      searcher = GuardianSearcher::Search.new(api_key: "test")

      expect(Faraday).to receive(:get) do |url, _params, headers|
        expect(url).to include("q=hello+%26+goodbye")
        expect(headers).to include("api-key" => "test")
      end

      searcher.search("hello & goodbye")
    end

    it "URL-encodes special characters in option values" do
      searcher = GuardianSearcher::Search.new(api_key: "test")

      expect(Faraday).to receive(:get) do |url, _params, headers|
        expect(url).to include("page-size=10")
        expect(url).to include("from-date=2022-01-01")
        expect(headers).to include("api-key" => "test")
      end

      searcher.search("test", { page_size: 10, from_date: "2022-01-01" })
    end

    it "returns a 200" do
      VCR.use_cassette("returns_a_200") do
        response = described_class.search(search_term)
        expect(response.status).to eq(200)
      end
    end

    it "returns a 401 if unauthorised" do
      VCR.use_cassette("returns_a_401") do
        searcher = GuardianSearcher::Search.new(api_key: "xxxtest")
        response = searcher.search(search_term)
        expect(response.status).to eq(401)
      end
    end
  end

  describe "#search_sections", :vcr do
    let(:described_class) { GuardianSearcher::Search.new(api_key: "test") }
    let(:search_term) { "politics" }

    it "returns a 200" do
      VCR.use_cassette("section_returns_a_200") do
        response = described_class.search_sections(search_term)
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#search_tags", :vcr do
    let(:described_class) { GuardianSearcher::Search.new(api_key: "test") }
    let(:search_term) { "football" }

    it "returns a 200" do
      VCR.use_cassette("tags_returns_a_200") do
        response = described_class.search_tags(search_term)
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#find_article" do
    it "builds the correct URL with no options" do
      searcher = GuardianSearcher::Search.new(api_key: "test")

      expect(Faraday).to receive(:get) do |url, _params, headers|
        expect(url).to eq("https://content.guardianapis.com/world/2024/jun/28/test-article")
        expect(headers).to include("api-key" => "test")
      end

      searcher.find_article("world/2024/jun/28/test-article")
    end

    it "appends options as query string when provided" do
      searcher = GuardianSearcher::Search.new(api_key: "test")

      expect(Faraday).to receive(:get) do |url, _params, headers|
        expect(url).to include("page-size=10")
        expect(headers).to include("api-key" => "test")
      end

      searcher.find_article("world/2024/jun/28/test-article", page_size: 10)
    end

    it "returns a 200", :vcr do
      VCR.use_cassette("single_article_returns_a_200") do
        searcher = GuardianSearcher::Search.new(api_key: "test")
        response = searcher.find_article("politics")
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#search_editions", :vcr do
    let(:described_class) { GuardianSearcher::Search.new(api_key: "test") }
    let(:search_term) { "canada" }

    it "returns a 200" do
      VCR.use_cassette("editons_returns_a_200") do
        response = described_class.search_editions(search_term)
        expect(response.status).to eq(200)
      end
    end
  end
end
