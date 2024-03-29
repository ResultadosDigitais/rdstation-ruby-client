# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdstation/version'

Gem::Specification.new do |spec|
  spec.name          = "rdstation-ruby-client"
  spec.version       = RDStation::VERSION
  spec.authors       = ["Paulo L F Casaretto"]
  spec.email         = ["paulo.casaretto@resultadosdigitais.com.br"]
  spec.description   = "Ruby API wrapper for RD Station"
  spec.summary       = "Ruby API wrapper for RD Station"
  spec.homepage      = "https://github.com/ResultadosDigitais/rdstation-ruby-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'turn'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'pry'

  spec.add_dependency "httparty", "~> 0.12"
end
