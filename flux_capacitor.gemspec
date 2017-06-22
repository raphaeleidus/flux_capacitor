# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flux_capacitor/version"

Gem::Specification.new do |spec|
  spec.name          = "flux_capacitor"
  spec.version       = Flux::VERSION
  spec.authors       = ["Raphael Eidus"]
  spec.email         = ["raphaeleidus@gmail.com"]

  spec.summary       = %q{Utility for progressively rolling out a feature to existing content}
  spec.description   = File.read('README.md')
  spec.homepage      = "https://github.com/raphaeleidus/flux_capacitor"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "murmurhash3"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
