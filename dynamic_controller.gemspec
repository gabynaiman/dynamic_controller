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

  s.add_dependency 'ransack'
  s.add_dependency 'kaminari'
  s.add_dependency 'nql', '0.0.1'

  s.add_development_dependency 'rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
end
