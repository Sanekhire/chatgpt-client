# frozen_string_literal: true

require_relative "lib/chatgpt/version"

Gem::Specification.new do |spec|
  spec.name = "chatgpt-ruby-client"
  spec.version = Chatgpt::VERSION
  spec.authors = ["Sanekhire"]
  spec.email = ["sanchoshire@gmail.com"]

  spec.summary = "ChatGPT API Client на основе Curb для уникализации текста."
  spec.description = "Библиотека для работы с OpenAI API через Curb."
  spec.homepage = "https://github.com/Sanekhire/chatgpt-ruby-client"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Sanekhire/chatgpt-ruby-client"
  spec.metadata["changelog_uri"] = "https://github.com/Sanekhire/chatgpt-ruby-client/blob/master/CHANGELOG.md"

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

  spec.add_dependency "curb", "~> 1.0"
  spec.add_dependency "json", "~> 2.10"

  spec.metadata["rubygems_mfa_required"] = "true"
end
