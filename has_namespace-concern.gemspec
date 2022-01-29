# frozen_string_literal: true

require_relative "lib/has_namespace/concern/version"

Gem::Specification.new do |spec|
  spec.authors       = ["Benjamin J. Anderson"]
  spec.email         = ["andeb2804@gmail.com"]

  spec.name          = "has_namespace-concern"
  spec.version       = HasNamespace::Concern::VERSION
  spec.summary       = %q{Contextual serialization of Rails models.}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/Vandise"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/Vandise"
    spec.metadata["changelog_uri"] = "https://github.com/Vandise/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  rails_versions = ['>= 4.1', '< 7.0']

  spec.add_dependency "activesupport", "~> 5.0"
  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord', rails_versions
end
