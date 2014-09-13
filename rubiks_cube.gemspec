# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubiks_cube/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubiks_cube'
  spec.version       = RubiksCube::VERSION
  spec.authors       = ['Chris Hunt']
  spec.email         = ['c@chrishunt.co']
  spec.description   = %q{Solve your Rubik's Cube with a two-cycle solution}
  spec.summary       = %q{Solve your Rubik's Cube with a two-cycle solution}
  spec.homepage      = 'https://github.com/chrishunt/rubiks-cube'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7.2'
  spec.add_development_dependency 'rake',    '~> 10.3.2'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cane-hashcheck'
  spec.add_development_dependency 'coveralls'
end
