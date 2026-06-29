# frozen_string_literal: true

RSpec.describe GuardianSearcher::Search do
  let(:api_key) { "env_test_key" }
  let(:query) { "technology" }
  let(:options) { { page_size: 10 } }

  before do
    # Mock the environment variable required by the class methods
    allow(ENV).to receive(:[]).with("guardian_api_key").and_return(api_key)
  end

  describe ".search_articles" do
    it "initializes a new search instance with the ENV key and calls #search" do
      # Create an instance double to verify delegation
      search_instance = instance_double(GuardianSearcher::Search)

      # Expect Search.new to be called with the key from the environment
      allow(GuardianSearcher::Search).to receive(:new).with(api_key: api_key).and_return(search_instance)

      # Verify that the instance method #search is called with correct arguments
      expect(search_instance).to receive(:search).with(query, options)

      GuardianSearcher::Search.search_articles(query, options)
    end
  end

  describe ".find_article" do
    let(:article_id) { "world/2024/jun/28/test-article" }

    it "initializes a new search instance with the ENV key and calls #find_article" do
      search_instance = instance_double(GuardianSearcher::Search)

      allow(GuardianSearcher::Search).to receive(:new).with(api_key: api_key).and_return(search_instance)

      expect(search_instance).to receive(:find_article).with(article_id, options)

      GuardianSearcher::Search.find_article(article_id, options)
    end
  end

  describe ".search_sections" do
    it "initializes a new search instance with the ENV key and calls #search_sections" do
      search_instance = instance_double(GuardianSearcher::Search)

      allow(GuardianSearcher::Search).to receive(:new).with(api_key: api_key).and_return(search_instance)

      # Verify that the instance method #search_sections is called with correct arguments
      expect(search_instance).to receive(:search_sections).with(query, options)

      GuardianSearcher::Search.search_sections(query, options)
    end
  end
end
