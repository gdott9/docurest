# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docurest/version'

Gem::Specification.new do |spec|
  spec.name          = "docurest"
  spec.version       = Docurest::VERSION
  spec.authors       = ["Guillaume Dott"]
  spec.email         = ["guillaume+github@dott.fr"]

  spec.summary       = %q{Client Library used to interact with the DocuSign REST API}
  spec.homepage      = "https://github.com/gdott9/docurest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
