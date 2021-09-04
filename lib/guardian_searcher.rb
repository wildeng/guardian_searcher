# frozen_string_literal: true

require_relative "guardian_searcher/version"
require "faraday"
require_relative "guardian_searcher/base"
require_relative "guardian_searcher/search"
require_relative "guardian_searcher/search_result"
require_relative "guardian_searcher/section_result"
require_relative "guardian_searcher/options"

module GuardianSearcher
  class Error < StandardError; end
  class GuardianApyKeyError < StandardError; end
end
