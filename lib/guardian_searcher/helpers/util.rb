# frozen_string_literal: true

module GuardianSearcher
  module Helpers
    module Util
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
