# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','relastic_version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'relastic'
  s.version = Relastic::VERSION
  s.author = 'Martin Schneider & Eric Starke'
  s.email = 'relastic@outsmartin.de'
  s.homepage = 'http://www.outsmartin.de'
  s.platform = Gem::Platform::RUBY
  s.summary = 'relastic provides a interface to work with Elastic Bunch Graph Matching on faces. It is based on work of David S. Bolme
  who wrote his master thesis about EBGM.'
# Add your other files here if you make them
  s.files = %w(
bin/relastic
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','relastic.rdoc']
  s.rdoc_options << '--title' << 'relastic' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'relastic'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
end
