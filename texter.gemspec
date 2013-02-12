# encoding: UTF-8
require File.expand_path('../lib/texter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["J. Pablo Fernández"]
  gem.email         = ["pupeno@watuhq.com"]
  gem.description   = %q{Generic interface to send SMS with Ruby}
  gem.summary       = %q{Generic interface to send SMS with Ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "texter"
  gem.require_paths = ["lib"]
  gem.version       = Texter::VERSION
end
