# frozen_string_literal: true

require_relative "guardian_searcher/version"
require "faraday"
require_relative "guardian_searcher/base"
require_relative "guardian_searcher/helpers/util"
require_relative "guardian_searcher/helpers/generator"
require_relative "guardian_searcher/content"
require_relative "guardian_searcher/search"
require_relative "guardian_searcher/search_result"
require_relative "guardian_searcher/section_result"
require_relative "guardian_searcher/options"

module GuardianSearcher
  class Error < StandardError; end
  class GuardianApyKeyError < StandardError; end
  class GuardianUnauthorizedError < StandardError; end
  class GuardianBadRequestError < StandardError; end
  class GuardianInternalServerError < StandardError; end
  class GuardianUnknownError < StandardError; end
  class GuardianSearcherUndefinedResponse < StandardError; end
  class OptionsNotHashError < StandardError; end
  class OptionsNotSupportedError < StandardError; end
end
