# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iibee/version'

Gem::Specification.new do |spec|
  spec.name          = "iibee"
  spec.version       = Iibee::VERSION
  spec.authors       = ["akil"]
  spec.email         = ["akhilesh.kataria@quantiguous.com"]

  spec.summary       = %q{Gem to wrap the IIB 9 REST API.}
  spec.description   = %q{Gem to wrap the IIB 9 REST API.}
  spec.homepage      = "http://quantiguous.com."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"  
  spec.add_development_dependency "codeclimate-test-reporter"  
  spec.add_development_dependency "m"
  
  spec.add_dependency "net-http-persistent"
  spec.add_dependency "faraday"
  spec.add_dependency "oga"
end
