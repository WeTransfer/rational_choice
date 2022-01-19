# frozen_string_literal: true

require_relative "lib/rational_choice/version"

Gem::Specification.new do |spec|
  spec.name = "rational_choice"
  spec.version = RationalChoice::VERSION
  spec.authors = ["Julik Tarkhanov", "grdw"]
  spec.email = ["me@julik.nl", "gerard@wetransfer.com"]

  spec.summary = "Makes life-concerning choices based on an informed coin toss"
  spec.description = "Fuzzy logic gate"
  spec.homepage = "https://github.com/wetransfer/rational_choice"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13"
  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency "wetransfer_style", "1.0.0"
end
