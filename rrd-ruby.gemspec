# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rrd/version'

Gem::Specification.new do |spec|
  spec.name          = "rrd-ruby"
  spec.version       = RRD::VERSION
  spec.authors       = ["Igor Yamolov"]
  spec.email         = ["iyamolov@spbtv.com"]
  spec.description   = %q{Native RRD file reader}
  spec.summary       = %q{Native ruby RRD file parser}
  spec.homepage      = "https://github.com/t3hk0d3/rrd-ruby"
  spec.license       = "LGPL"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "minitest", "~> 5.2"
  spec.add_development_dependency "ruby-prof", "~> 0.14"
  spec.add_development_dependency "shoulda", "~> 3.5"
  spec.add_development_dependency "shoulda-context", "~> 1.2"
end
