# frozen_string_literal: true

require_relative "lib/bakool/version"

Gem::Specification.new do |spec|
  spec.name = "bakool"
  spec.version = Bakool::VERSION
  spec.authors = ["Fadhil Luqman"]
  spec.email = ["fadhil.luqman@gmail.com"]

  spec.summary = "A flexible Ruby library for managing shopping baskets with support for " \
                 "products, delivery charges, and discount strategies."
  spec.homepage = "https://github.com/fadhil-luqman/bakool"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fadhil-luqman/bakool"
  spec.metadata["changelog_uri"] = "https://github.com/fadhil-luqman/bakool/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ["README.md"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
