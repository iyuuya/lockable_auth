# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knock_lockable/version'

Gem::Specification.new do |spec|
  spec.name          = 'knock_lockable'
  spec.version       = KnockLockable::VERSION
  spec.authors       = ['iyuuya']
  spec.email         = ['i.yuuya@gmail.com']

  spec.summary       = 'Account lock with knock'
  spec.description   = 'Account lock with knock'
  spec.homepage      = 'https://github.com/iyuuya/knock_lockable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = `git ls-files -z -- spec/*`.split("\0")
  spec.require_paths = ['lib']

  spec.add_dependency 'knock', '~> 1.5'
  spec.add_dependency 'rails', '>= 4.2'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.1'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
end
