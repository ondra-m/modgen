# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modgen/version'

Gem::Specification.new do |spec|
  spec.name          = "modgen"
  spec.version       = Modgen::VERSION
  spec.authors       = ["Ondřej Moravčík"]
  spec.email         = ["moravcik.ondrej@gmail.com"]
  spec.description   = %q{Modgen allow discover and use modgen's API}
  spec.summary       = %q{Gem for using modgen's API}
  spec.homepage      = "https://github.com/ondra-m/modgen"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "multi_json"
  spec.add_dependency "mimemagic"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
