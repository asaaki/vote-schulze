# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vote/schulze/version'

Gem::Specification.new do |spec|
  spec.name          = 'vote-schulze'
  spec.version       = Vote::Schulze::VERSION
  spec.authors       = ['Christoph Grabo']
  spec.email         = ['asaaki@mannaz.cc']

  spec.summary       = 'Schulze method implementation (a type of the Condorcet method)'
  spec.description   = 'This gem is a Ruby implementation of the Schulze voting method (using Floyd–Warshall ' \
                       'algorithm), a type of the Condorcet voting methods.'
  spec.homepage      = 'https://github.com/asaaki/vote-schulze'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0'

  spec.add_runtime_dependency 'matrix', '>= 0.4.2'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.82'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.39'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
