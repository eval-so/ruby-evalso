# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evalso/version'

Gem::Specification.new do |spec|
  spec.name          = "evalso"
  spec.version       = Evalso::VERSION
  spec.authors       = ["Ellen Marie Dash"]
  spec.email         = ["me@duckie.co"]
  spec.description   = %q{Evaluates code safely, via http://eval.so}
  spec.summary       = %q{Evaluates code safely, via http://eval.so}
  spec.homepage      = "http://github.com/eval-so/ruby-evalso"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
