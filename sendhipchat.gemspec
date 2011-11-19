# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sendhipchat/version"

Gem::Specification.new do |s|
  s.name        = "sendhipchat"
  s.version     = Sendhipchat::VERSION
  s.authors     = ["Brian L. Troutwine"]
  s.email       = ["brian@troutwine.us"]
  s.homepage    = "https://github.com/blt/sendhipchat"
  s.summary     = %q{A sendmail alike tool for HipChat.}
  s.description = %q{Send room messages to HipChat with an interface inspired by sendmail.}

  s.rubyforge_project = "sendhipchat"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'hipchat-api', '~> 1.0.2'
end
