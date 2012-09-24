# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fomi2inspire/version'

Gem::Specification.new do |gem|
  gem.name          = "fomi2inspire"
  gem.version       = Fomi2inspire::VERSION
  gem.authors       = ["Nguyen Thai Binh"]
  gem.email         = ["posseidon@gmail.com"]
  gem.description   = %q{Tool for transforming FOMI data to Inspire data format (gml)}
  gem.summary       = %q{Transformation using sequel}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
