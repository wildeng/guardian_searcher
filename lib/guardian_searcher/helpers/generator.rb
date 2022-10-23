# frozen_string_literal: true

module GuardianSearcher
  module Helpers
    # The class helps generating an array of object from the passed parameters
    # It can be used to generate e.g. an array of Content objects, each one
    # initialised with the data of a single results Hash coming from the Guardian
    # API response
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
