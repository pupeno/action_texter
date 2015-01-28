# encoding: UTF-8
# Copyright © 2013, 2014, 2015, Carousel Apps

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "action_texter/version"

Gem::Specification.new do |spec|
  spec.name          = "action_texter"
  spec.version       = ActionTexter::VERSION
  spec.authors       = ["J. Pablo Fernández", "Daniel Magliola"]
  spec.email         = ["info@carouselapps.com"]
  spec.homepage      = "http://carouselapps.com/action_texter"
  spec.description   = %q{Generic interface to send SMS with Ruby}
  spec.summary       = %q{Generic interface to send SMS with Ruby}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"
end
