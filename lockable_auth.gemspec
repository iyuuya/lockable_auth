# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lockable_auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'lockable_auth'
  spec.version       = LockableAuth::VERSION
  spec.authors       = %w[iyuuya shiva]
  spec.email         = ['i.yuuya@gmail.com', 'nadarshiva.r@gmail.com']

  spec.summary       = 'Lock when authentication fails'
  spec.description   = 'Lock when authentication fails'
  spec.homepage      = 'https://github.com/iyuuya/lockable_auth'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = `git ls-files -z -- spec/*`.split("\0")
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.2'
  spec.add_development_dependency 'activemodel', '>= 4.2'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.1'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
  spec.add_development_dependency 'generator_spec'
end
