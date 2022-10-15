# frozen_string_literal: true

module GuardianSearcher
  module Helpers
    class Generator
      def generate(results, klass)
        content = []
        results.each do |result|
          content << Object.const_get(klass).new(result)
        end
        content
      end
    end
  end
end
