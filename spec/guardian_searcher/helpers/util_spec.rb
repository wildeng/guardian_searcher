# frozen_string_literal: true

RSpec.describe GuardianSearcher::Helpers::Util do
  describe "#snakecase" do
    class Dummy
      include GuardianSearcher::Helpers::Util
    end

    let(:dummy) { Dummy.new }
    it "converts to snakecase from CamelCase" do
      expect(dummy.snakecase("CamelCase")).to eq("camel_case")
      expect(dummy.snakecase("camelCase")).to eq("camel_case")
      expect(dummy.snakecase("camelCase_case")).to eq("camel_case_case")
    end

    it "does not change to snake_case" do
      expect(dummy.snakecase("snake_case")).to eq("snake_case")
    end

    it "ignores the key if not a string" do
      expect(dummy.snakecase(1)).to eq(nil)
      expect(dummy.snakecase(:tesCamel)).to eq(nil)
    end
  end
end
