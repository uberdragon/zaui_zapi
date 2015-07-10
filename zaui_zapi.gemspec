# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "zaui_zapi"
  spec.version       = VERSION
  spec.authors       = ['Shane Kretzmann']
  spec.email         = ["Shane.Kretzmann@gmail.com"]
  spec.summary       = %q{Zaui zAPI interface gem}
  spec.description   = %q{This is a cool ass core data gem.}
  spec.homepage      = ""
  spec.license       = "GNU GENERAL PUBLIC LICENSE Version 2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency "activerecord", "~> 4.2.0"
end
