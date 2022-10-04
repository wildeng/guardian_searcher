# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require "guardian_searcher"
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.hook_into                :faraday
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
