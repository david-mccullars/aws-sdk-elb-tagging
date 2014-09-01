# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'aws-sdk-elb-tagging'
  spec.version       = '1.52.0'
  spec.authors       = ['David McCullars']
  spec.email         = ['david.mccullars@gmail.com']
  spec.summary       = %q{Provides SDK support for AWS ELB tagging.}
  spec.description   = %q{Provides SDK support for AWS ELB tagging.}
  spec.license       = 'Apache License, Version 2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_runtime_dependency 'aws-sdk', '~> 1.52'
end
