# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brick/version"

Gem::Specification.new do |s|
  s.name        = "brick"
  s.version     = Brick::VERSION
  s.authors     = ["Victor Cavalcanti"]
  s.email       = ["victorc.rodrigues@gmail.com"]
  s.homepage    = "http://github.com/rodrigues/brick"
  s.summary     = "Deploy debian packages using bricklayer"
  s.description = "Creates a testing tag, waits for bricklayer to build the debian package and then updates your server"

  s.rubyforge_project = "brick"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec",     "~> 2.6"

  s.add_runtime_dependency "slop",          "~> 2.1"
  s.add_runtime_dependency "json",          "~> 1.5"
  s.add_runtime_dependency "rest-client",   "~> 1.6"
end
