# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubiks_cube/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubiks_cube'
  spec.version       = RubiksCube::VERSION
  spec.authors       = ['Chris Hunt']
  spec.email         = ['c@chrishunt.co']
  spec.description   = %q{Learn how to solve the Rubik's Cube. It's easy!}
  spec.summary       = %q{Learn how to solve the Rubik's Cube. It's easy!}
  spec.homepage      = 'https://github.com/chrishunt/rubiks-cube'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cane-hashcheck'
end
