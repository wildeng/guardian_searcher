# frozen_string_literal: true

require_relative "lib/guardian_searcher/version"

Gem::Specification.new do |spec|
  spec.name          = "guardian_searcher"
  spec.version       = GuardianSearcher::VERSION
  spec.authors       = "Alain Mauri"
  spec.email         = "wildeng@hotmail.com"

  spec.summary       = "A wrapper to search articles from The Guardian, using its open API.
    You need to register and get your api key to properly use this gem.
    It uses Faraday to make the API calls and has some classes that should help in formatting
    the results as easy to manage Ruby object."
  spec.homepage      = "https://alainmauri.eu"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = "https://github.com/wildeng/guardian_searcher"
  spec.metadata["source_code_uri"] = "https://github.com/wildeng/guardian_searcher"
  spec.metadata["changelog_uri"] = "https://github.com/wildeng/guardian_searcher/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "faraday", "~> 2.2"

  spec.add_development_dependency "byebug", "~> 11"
  spec.add_development_dependency "guard", "~> 2.18"
  spec.add_development_dependency "guard-bundler", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "vcr", "~> 6.1"
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
