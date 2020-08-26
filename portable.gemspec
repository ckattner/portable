# frozen_string_literal: true

require './lib/portable/version'

Gem::Specification.new do |s|
  s.name        = 'portable'
  s.version     = Portable::VERSION
  s.summary     = 'Virtual Document Modeling and Rendering Engine'

  s.description = <<-DESCRIPTION
    Portable is a virtual document object modeling library.  Out of the box is provides a CSV writer but others for other formats like Microsoft Excel could easily be implemented and used.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mruggio@bluemarblepayroll.com']
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir      = 'exe'
  s.executables = []
  s.homepage    = 'https://github.com/bluemarblepayroll/portable'
  s.license     = 'MIT'
  s.metadata    = {
    'bug_tracker_uri' => 'https://github.com/bluemarblepayroll/portable/issues',
    'changelog_uri' => 'https://github.com/bluemarblepayroll/portable/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/portable',
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage
  }

  s.required_ruby_version = '>= 2.5'

  s.add_dependency('acts_as_hashable', '~>1')
  s.add_dependency('objectable', '~>1')
  s.add_dependency('realize', '~>1.1')

  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('pry', '~>0')
  s.add_development_dependency('rake', '~> 13')
  s.add_development_dependency('rspec', '~> 3.8')
  s.add_development_dependency('rubocop', '~>0.88.0')
  s.add_development_dependency('simplecov', '~>0.18.5')
  s.add_development_dependency('simplecov-console', '~>0.7.0')
end
