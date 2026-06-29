# frozen_string_literal: true

RSpec.describe GuardianSearcher::Options do
  let(:valid_params) { { from_date: "2022-10-01", to_date: "2023-10-11",page_size: 10, page: "test" } }
  subject { described_class.new(valid_params) }

  describe "#initialize" do
    it "raises OptionsNotHashError if the input is not a Hash" do
      # Verifies the guard clause in the constructor [3, 4]
      expect { described_class.new("not a hash") }.to raise_error(GuardianSearcher::OptionsNotHashError)
    end

    it "successfully initializes with a Hash" do
      expect { subject }.not_to raise_error
    end
  end

  describe "dynamic method access (metaprogramming)" do
    it "allows accessing option keys as methods via method_missing" do
      # Tests the implementation of method_missing [2]
      expect(subject.from_date).to eq("2022-10-01")
      expect(subject.page_size).to eq(10)
    end

    it "correctly reports respond_to? for valid option keys" do
      # Tests the implementation of respond_to_missing? [3]
      expect(subject.respond_to?(:from_date)).to be true
      expect(subject.respond_to?(:page)).to be true
    end

    it "raises NoMethodError and returns false for respond_to? on non-existent keys" do
      expect { subject.invalid_key }.to raise_error(NoMethodError)
      expect(subject.respond_to?(:invalid_key)).to be false
    end
  end

  describe "#valid_option?" do
    it "raises OptionsNotSupportedError for keys not in the whitelist" do
      # The whitelist is currently [:from_date, :to_date, :page_size, :page] [3, 4]
      expect { subject.valid_option?(:unsupported_filter) }.to raise_error(GuardianSearcher::OptionsNotSupportedError)
    end

    it "does not raise an error for whitelisted keys" do
      expect { subject.valid_option?(:to_date) }.not_to raise_error
    end
  end

  describe "#map_option" do
    it "correctly translates Ruby symbols to Guardian API hyphenated strings" do
      # Tests the mapping hash used for API query construction [5]
      expect(subject.map_option(:from_date)).to eq("from-date")
      expect(subject.map_option(:page_size)).to eq("page-size")
      expect(subject.map_option(:to_date)).to eq("to-date")
    end
  end

  describe "#build_options" do
    it "constructs a formatted query string from the provided hash" do
      # build_options iterates through keys, validates them, and maps them to the string [3]
      built_string = subject.build_options
      expect(built_string).to include("&from-date=2022-10-01")
      expect(built_string).to include("&page-size=10")
    end

    it "returns an empty hash (representation) if options are empty" do
      # Verifies the guard clause for empty options [3]
      empty_opts = described_class.new({})
      expect(empty_opts.build_options).to eq({})
    end
  end
end
