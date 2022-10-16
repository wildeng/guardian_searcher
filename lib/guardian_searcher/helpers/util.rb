# frozen_string_literal: true

module GuardianSearcher
  module Helpers
    module Util
      # this method comes from the facets library
      # I took it from there because it was easier for
      # what I have in mind
      #
      # original here https://github.com/rubyworks/facets
      # docs here https://www.rubydoc.info/github/rubyworks/facets/String:snakecase
      def snakecase(key)
        return unless key.is_a? String

        key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2')
           .tr("-", "_")
           .gsub(/\s/, "_")
           .gsub(/__+/, "_")
           .downcase
      end
    end
  end
end
