# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dynamic_controller/version"

Gem::Specification.new do |s|
  s.name        = 'dynamic_controller'
  s.version     = DynamicController::VERSION
  s.authors     = ['Gabriel Naiman']
  s.email       = ['gabynaiman@gmail.com']
  s.homepage    = 'https://github.com/gabynaiman/dynamic_controller'
  s.summary     = 'Simple way to add CRUD actions into Rails controllers'
  s.description = 'Simple way to add CRUD actions into Rails controllers'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'ransack', '~> 0.7'
  s.add_dependency 'kaminari', '~> 0.13'
  s.add_dependency 'nql', '~> 0.1'

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "simplecov"
  s.add_development_dependency 'rails', '~> 3.2'
  s.add_development_dependency 'sqlite3', '~> 1.3.0'
  s.add_development_dependency 'rspec-rails', '~> 2.12'
  s.add_development_dependency 'factory_girl_rails', '~> 3.4'
end
