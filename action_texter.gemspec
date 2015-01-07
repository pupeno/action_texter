# encoding: UTF-8
# Copyright © 2013, 2014, 2015, Watu

require File.expand_path('../lib/action_texter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["J. Pablo Fernández"]
  gem.email         = ["info@watuhq.com"]
  gem.description   = %q{Generic interface to send SMS with Ruby}
  gem.summary       = %q{Generic interface to send SMS with Ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "action_texter"
  gem.require_paths = ["lib"]
  gem.version       = ActionTexter::VERSION
end
