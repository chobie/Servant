# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/servant/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shuhei Tanuma"]
  gem.email         = ["chobieee@gmail.com"]
  gem.description   = "Jenkins job management tool"
  gem.summary       = "Servant is a tool for applying jenkins job"
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "servant"
  gem.require_paths = ["lib"]
  gem.version       = Servant::VERSION
end
