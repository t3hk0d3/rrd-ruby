# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rrd/version'

Gem::Specification.new do |spec|
  spec.name          = "rrd-ruby"
  spec.version       = RRD::VERSION
  spec.authors       = ["Igor Yamolov"]
  spec.email         = ["iyamolov@spbtv.com"]
  spec.description   = %q{Native RRD tool implementation}
  spec.summary       = %q{Native RRD tool implementation}
  spec.homepage      = ""
  spec.license       = "LGPL"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "ruby-prof"
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "shoulda-context"
end
