# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "database_specification/version"

Gem::Specification.new do |s|
  s.name        = "database_specification"
  s.version     = DatabaseSpecification::VERSION
  s.authors     = ["Justin Love"]
  s.email       = ["git@JustinLove.name"]
  s.homepage    = ""
  s.summary     = %q{Translate between different ways of specifying a database connection - eg AR-URL}
  s.description = %q{Translate between different ways of specifying a database connection.  Translates between ActiveRecord-hash, Sequel-hash, and urls used by Sequel and Heroku}

  s.rubyforge_project = "database_specification"

  s.files         = <<MANIFEST.split("\n")
lib/database_specification.rb
lib/database_specification/version.rb
MANIFEST
  s.test_files    = <<TEST_MANIFEST.split("\n")
spec/database_specification_spec.rb
TEST_MANIFEST
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
end
