# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mvn2chain/version'

Gem::Specification.new do |spec|
  spec.name          = 'mvn2chain'
  spec.version       = Mvn2chain::VERSION
  spec.authors       = ['Eric Henderson']
  spec.email         = ['henderea@gmail.com']
  spec.summary       = %q{A command line tool that makes it easy to chain mvn2 calls.}
  spec.description   = %q{A command line tool that makes it easy to chain mvn2 calls.  Register your dependencies with the "mvn2chain dep" commands and run them with the "mvn2chain exec" command.  See "mvn2chain help", "mvn2chain help dep", and "mvn2chain help exec" for more information.  Some commands have aliases.}
  spec.homepage      = 'https://github.com/henderea/mvn2chain'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.4'

  spec.add_dependency 'everyday-cli-utils', '~> 1.8', '>= 1.8.2'
  spec.add_dependency 'everyday-plugins', '~> 1.2'
  spec.add_dependency 'everyday_thor_util', '~> 2.0', '>= 2.0.5'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'mvn2', '~> 2.6', '>= 2.6.7'
end
