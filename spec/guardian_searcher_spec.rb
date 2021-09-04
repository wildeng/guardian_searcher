# frozen_string_literal: true

RSpec.describe GuardianSearcher do
  it "has a version number" do
    expect(GuardianSearcher::VERSION).not_to be nil
  end

  it "returns an error if api key is not set" do
    expect { GuardianSearcher::Search.new }.to raise_error(GuardianSearcher::GuardianApyKeyError)
  end

  it "sets an api_key variable if api_key is set" do
    searcher = GuardianSearcher::Search.new(api_key: "test")
    expect(searcher.api_key).to eq("test")
  end
end
