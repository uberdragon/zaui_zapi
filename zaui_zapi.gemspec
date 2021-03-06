# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "zaui_zapi"
  spec.version       = VERSION
  spec.authors       = ['Shane Kretzmann']
  spec.email         = ["Shane.Kretzmann@gmail.com"]
  spec.summary       = %q{Zaui.com zAPI interface gem}
  spec.description   = %q{Provide ruby methods to interact with Zaui zAPI}
  spec.homepage      = "https://github.com/uberdragon/zaui_zapi"
  spec.license       = "GNU GENERAL PUBLIC LICENSE Version 2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency 'rails'
  spec.add_runtime_dependency 'activesupport'
end
