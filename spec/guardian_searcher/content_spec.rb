# frozen_string_literal: true

RSpec.describe GuardianSearcher::Content do
  context "when initialize" do
    let(:string_keys) do
      { "foo" => "foo", "bar" => "bar", "foobar" => "foobar" }
    end

    let(:sym_keys) do
      { "foo": "foo", "bar": "bar", "foobar": "foobar" }
    end
    it "creates the expected attributes from strings" do
      content = GuardianSearcher::Content.new(string_keys)
      expect(content.foo).to eq("foo")
      expect(content.bar).to eq("bar")
      expect(content.foobar).to eq("foobar")
    end

    it "creates the expected attributes from symbols" do
      content = GuardianSearcher::Content.new(sym_keys)
      expect(content.foo).to eq("foo")
      expect(content.bar).to eq("bar")
      expect(content.foobar).to eq("foobar")
    end
  end
end
