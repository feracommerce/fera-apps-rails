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
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "cssbundling-rails", "~> 1.1"
  spec.add_dependency "dotenv-rails", "~> 2.8.1"
  spec.add_dependency "httparty", "~> 0.20"
  spec.add_dependency "jsbundling-rails", "~> 1.0"
  spec.add_dependency "omniauth-fera" # We're ok not locking this version because it is our own library
  spec.add_dependency "omniauth-oauth2", "~> 1.3"
  spec.add_dependency "pg", "~> 1.2"
  spec.add_dependency "puma", "~> 5.4"
  spec.add_dependency "rails", "~> 6.1"
  spec.add_dependency "redis", "~> 4.7.1"
  spec.add_dependency "sass-rails", "~> 6.0"
  spec.add_dependency "to_bool", "~> 2.0"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "webmock", ">= 3.0"
end
