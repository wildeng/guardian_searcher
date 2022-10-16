# frozen_string_literal: true

# frozen_string_literal

RSpec.describe GuardianSearcher::Helpers::Generator do
  context "when generating a class" do
    describe "#generate" do
      class Dummy
        attr_accessor :foo, :bar

        def initialize(opts = {})
          @foo = opts[:foo]
          @bar = opts[:bar]
        end
      end
      let(:described_class) { GuardianSearcher::Helpers::Generator.new }

      it "generates the expected class" do
        params = [{ foo: "foo", bar: "bar" }]
        dummy_class = described_class.generate(params, "Dummy").first
        expect(dummy_class.is_a?(Dummy)).to eq(true)
        expect(dummy_class.foo).to eq("foo")
        expect(dummy_class.bar).to eq("bar")
      end
    end
  end
end
