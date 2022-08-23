# frozen_string_literal: true

require_relative "lib/fera/apps/rails/version"

Gem::Specification.new do |spec|
  spec.name = "fera-apps-rails"
  spec.version = Fera::Apps::Rails::VERSION
  spec.authors = ["Fera Commerce Inc"]
  spec.email = ["developers@fera.ai"]

  spec.summary = "Fera Rails App Gem"
  spec.description = "Checkout the Fera Rails App github repo to get started with a beautiful Fera App integration."
  spec.homepage = "https://developers.fera.ai"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["{lib,app}/**/*.rb", "LICENSE.txt", "README.md"]
  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = %w[lib app]

  spec.add_dependency "actionview", ">= 6.1"
  spec.add_dependency "activesupport", ">= 6.1"
  spec.add_dependency "fera-api" # We're ok not locking this version because it is our own library
  spec.add_dependency "omniauth-fera" # We're ok not locking this version because it is our own library
  spec.add_dependency "omniauth-oauth2", ">= 1.3"
  spec.add_dependency "rails", ">= 6.1"
  spec.add_dependency "railties", ">= 6.1"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "to_bool", "~> 2.0"
  spec.add_development_dependency "webmock", ">= 3.0"
end
